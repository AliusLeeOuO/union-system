package service

import (
	"encoding/json"
	"errors"
	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
	"time"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
)

type AssistanceService struct {
	Repo *repository.AssistanceRepository
}

func NewAssistanceService(repo *repository.AssistanceRepository) *AssistanceService {
	return &AssistanceService{Repo: repo}
}

// GetAssistanceList 用于获取工单列表
func (s *AssistanceService) GetAssistanceList(form dto2.GetAssistanceListRequest) (dto2.GetAssistanceListResponse, error) {
	return s.Repo.GetAssistanceList(form)
}

// ViewAssistance 用于查看工单详情
func (s *AssistanceService) ViewAssistance(requestID uint) (domain.AssistanceRequest, []domain.AssistanceResponse, error) {
	return s.Repo.ViewAssistance(requestID)
}

// ReplyAssistance 用于回复工单
func (s *AssistanceService) ReplyAssistance(requestID, responderID uint, responseText string, newStatusID uint) error {
	// 检查工单状态
	assistanceRequest, err := s.Repo.GetAssistanceRequest(requestID)
	if err != nil {
		return err
	}

	// 检查工单是否已关闭
	closedStatusID := uint(4) // 4 为“已关闭”的状态ID
	if assistanceRequest.StatusID == closedStatusID {
		return errors.New("cannot reply to a closed assistance request")
	}

	// 使用事务创建回复记录并更新工单状态
	return s.Repo.AdminReplyToAssistance(requestID, responderID, responseText, newStatusID)
}

// CreateNewAssistance 用户创建新的工单
func (s *AssistanceService) CreateNewAssistance(memberID uint, request dto2.NewAssistanceRequest) (uint, error) {
	newAssistance := domain.AssistanceRequest{
		MemberID:    memberID,
		TypeID:      request.TypeID,
		Title:       request.Title,
		Description: request.Description,
		StatusID:    1, // 1 为初始状态
		CreatedAt:   time.Now(),
	}

	id, err := s.Repo.CreateNewAssistance(&newAssistance)
	return id, err
}

// UserReplyAssistance 用户回复工单
func (s *AssistanceService) UserReplyAssistance(request dto2.UserReplyAssistanceRequest, userID uint) error {
	return s.Repo.ReplyToAssistance(request.RequestID, userID, request.ResponseText)
}

// CloseAssistance 关闭工单
func (s *AssistanceService) CloseAssistance(request dto2.CloseAssistanceRequest, userID uint) error {
	return s.Repo.CloseAssistanceRequest(request.RequestID, userID)
}

// GetAssistanceType 获取工单类型
func (s *AssistanceService) GetAssistanceType(c *fiber.Ctx) ([]dto2.GetAssistanceTypeRequest, error) {
	const cacheKey = "assistanceTypes"
	var response []dto2.GetAssistanceTypeRequest

	// 尝试从Redis缓存中获取数据
	cachedData, err := global.RedisClient.Get(c.Context(), cacheKey).Result()
	if errors.Is(err, redis.Nil) {
		// 缓存未命中，从数据库获取数据
		assistanceTypes, dbErr := s.Repo.GetAssistanceType()
		if dbErr != nil {
			return nil, dbErr
		}

		// 将数据库查询结果转换为响应数据
		for _, assistanceType := range assistanceTypes {
			response = append(response, dto2.GetAssistanceTypeRequest{
				AssistanceTypeId: assistanceType.AssistanceTypeID,
				TypeName:         assistanceType.TypeName,
			})
		}

		// 序列化并保存到Redis
		serialized, _ := json.Marshal(response)
		global.RedisClient.Set(c.Context(), cacheKey, serialized, 24*time.Hour) // 设置24小时过期
	} else if err != nil {
		// 处理Redis错误
		return nil, err
	} else {
		// 缓存命中，使用缓存的数据
		json.Unmarshal([]byte(cachedData), &response)
	}

	return response, nil
}

func (s *AssistanceService) GetMyAssistances(memberID uint, pageSize uint, pageNum uint) ([]dto2.MyAssistanceResponse, uint, uint, uint, error) {
	assistances, total, err := s.Repo.GetMyAssistances(memberID, pageSize, pageNum)
	if err != nil {
		return nil, 0, 0, 0, err
	}

	// 获取已解决和待审核的工单数量
	resolvedCount, err := s.Repo.GetAssistanceCountByStatus(memberID, 3) // resolvedStatusID是已解决状态的ID = 3
	if err != nil {
		return nil, 0, 0, 0, err
	}
	pendingReviewCount, err := s.Repo.GetAssistanceCountByStatus(memberID, 1) // pendingReviewStatusID是待审核状态的ID = 1
	if err != nil {
		return nil, 0, 0, 0, err
	}

	var responses []dto2.MyAssistanceResponse
	for _, a := range assistances {
		responses = append(responses, dto2.MyAssistanceResponse{
			AssistanceID:     a.RequestID,
			Description:      a.Description,
			RequestDate:      a.CreatedAt.Format(time.RFC3339),
			AssistanceTypeID: a.AssistanceType.AssistanceTypeID,
			AssistanceType:   a.AssistanceType.TypeName,
			StatusID:         a.StatusID,
			Title:            a.Title,
		})
	}
	return responses, total, resolvedCount, pendingReviewCount, nil
}

// GetAssistanceStatus 获取工单状态
func (s *AssistanceService) GetAssistanceStatus(c *fiber.Ctx) ([]dto2.AssistanceStatusResponse, error) {
	const assistanceStatusCacheKey = "assistanceStatuses"
	// 尝试从 Redis 缓存中读取
	cachedStatuses, err := global.RedisClient.Get(c.Context(), assistanceStatusCacheKey).Result()
	if err == nil && cachedStatuses != "" {
		var cachedResponse []dto2.AssistanceStatusResponse
		if err := json.Unmarshal([]byte(cachedStatuses), &cachedResponse); err == nil {
			return cachedResponse, nil // 返回缓存的数据
		}
	}
	// 如果缓存未命中或存在错误，从数据库加载
	statuses, err := s.Repo.GetAssistanceStatus()
	if err != nil {
		return nil, err
	}
	var response []dto2.AssistanceStatusResponse
	for _, status := range statuses {
		response = append(response, dto2.AssistanceStatusResponse{
			ID:   status.StatusID,
			Name: status.StatusName,
		})
	}

	// 将结果序列化并存储到 Redis 缓存中
	serialized, err := json.Marshal(response)
	if err == nil {
		global.RedisClient.Set(c.Context(), assistanceStatusCacheKey, serialized, 24*time.Hour) // 缓存 24 小时
	}
	return response, nil
}
