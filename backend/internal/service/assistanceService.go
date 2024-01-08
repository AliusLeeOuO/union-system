package service

import (
	"errors"
	"time"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
)

type AssistanceService struct {
	Repo *repository.AssistanceRepository
}

func NewAssistanceService(repo *repository.AssistanceRepository) *AssistanceService {
	return &AssistanceService{Repo: repo}
}

// GetAssistanceList 用于获取工单列表
func (s *AssistanceService) GetAssistanceList(form dto.GetAssistanceListRequest) (dto.GetAssistanceListResponse, error) {
	return s.Repo.GetAssistanceList(form)
}

// ViewAssistance 用于查看工单详情
func (s *AssistanceService) ViewAssistance(requestID uint) (model.AssistanceRequest, []model.AssistanceResponse, error) {
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
	closedStatusID := uint(4) // 假设 4 为“已关闭”的状态ID
	if assistanceRequest.StatusID == closedStatusID {
		return errors.New("cannot reply to a closed assistance request")
	}

	// 使用事务创建回复记录并更新工单状态
	return s.Repo.AdminReplyToAssistance(requestID, responderID, responseText, newStatusID)
}

// CreateNewAssistance 用户创建新的工单
func (s *AssistanceService) CreateNewAssistance(memberID uint, request dto.NewAssistanceRequest) error {
	newAssistance := model.AssistanceRequest{
		MemberID:    memberID,
		TypeID:      request.TypeID,
		Title:       request.Title,
		Description: request.Description,
		StatusID:    1, // 假设 1 为初始状态
		CreatedAt:   time.Now(),
	}

	err := s.Repo.CreateNewAssistance(newAssistance)
	return err
}

// UserReplyAssistance 用户回复工单
func (s *AssistanceService) UserReplyAssistance(request dto.UserReplyAssistanceRequest, userID uint) error {
	return s.Repo.ReplyToAssistance(request.RequestID, userID, request.ResponseText)
}

// CloseAssistance 关闭工单
func (s *AssistanceService) CloseAssistance(request dto.CloseAssistanceRequest, userID uint) error {
	return s.Repo.CloseAssistanceRequest(request.RequestID, userID)
}

// GetAssistanceType 获取工单类型
func (s *AssistanceService) GetAssistanceType() ([]dto.GetAssistanceTypeRequest, error) {
	assistanceTypes, err := s.Repo.GetAssistanceType()
	if err != nil {
		return nil, err
	}
	// 将数据库查询结果转换为响应数据
	var response []dto.GetAssistanceTypeRequest
	for _, assistanceType := range assistanceTypes {
		response = append(response, dto.GetAssistanceTypeRequest{
			AssistanceTypeId: assistanceType.AssistanceTypeID,
			TypeName:         assistanceType.TypeName,
		})
	}
	return response, nil
}
