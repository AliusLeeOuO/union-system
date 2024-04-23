package repository

import (
	"errors"
	"gorm.io/gorm"
	"time"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/model/domain"
)

type AssistanceRepository struct {
	DB *gorm.DB
}

func NewAssistanceRepository(db *gorm.DB) *AssistanceRepository {
	return &AssistanceRepository{DB: db}
}

func (r *AssistanceRepository) GetAssistanceList(form dto.GetAssistanceListRequest) (dto.GetAssistanceListResponse, error) {
	var assistances []model.AssistanceRequest
	var response dto.GetAssistanceListResponse

	// 创建一个查询用于计算总数
	countQuery := r.DB.Model(&model.AssistanceRequest{})
	if form.ID != 0 {
		countQuery = countQuery.Where("request_id = ?", form.ID)
	}
	if form.AssistanceTypeId != 0 {
		countQuery = countQuery.Where("type_id = ?", form.AssistanceTypeId)
	}

	// 计算总记录数
	var totalCount int64
	countQuery.Count(&totalCount)

	// 获取分页数据
	dataQuery := r.DB.Model(&model.AssistanceRequest{}).Preload("AssistanceType").Preload("User")
	if form.ID != 0 {
		dataQuery = dataQuery.Where("request_id = ?", form.ID)
	}
	if form.AssistanceTypeId != 0 {
		dataQuery = dataQuery.Where("type_id = ?", form.AssistanceTypeId)
	}

	// 添加倒序排列
	dataQuery = dataQuery.Order("created_at DESC")

	limit := form.PageSize
	offset := (form.PageNum - 1) * form.PageSize
	dataQuery = dataQuery.Offset(int(offset)).Limit(int(limit))

	if err := dataQuery.Find(&assistances).Error; err != nil {
		return response, err
	}

	// 填充响应数据
	response.Data = make([]dto.GetAssistanceResponse, len(assistances))
	for i, assistance := range assistances {
		response.Data[i] = dto.GetAssistanceResponse{
			ID:             assistance.RequestID,
			AssistanceType: dto.AssistanceTypeResponse{ID: assistance.TypeID, Name: assistance.AssistanceType.TypeName},
			Title:          assistance.Title,
			Description:    assistance.Description,
			Status:         assistance.StatusID,
			CreateTime:     assistance.CreatedAt.Format(time.RFC3339),
			UserID:         assistance.MemberID,
			Username:       assistance.User.Username,
		}
	}

	// 设置分页信息和总记录数
	response.PageSize = form.PageSize
	response.PageNum = form.PageNum
	response.Total = uint(totalCount)

	return response, nil
}

func (r *AssistanceRepository) ViewAssistance(requestID uint) (model.AssistanceRequest, []model.AssistanceResponse, error) {
	var assistance model.AssistanceRequest
	var responses []model.AssistanceResponse

	// 获取工单信息
	if err := r.DB.Preload("AssistanceType").First(&assistance, "request_id = ?", requestID).Error; err != nil {
		return assistance, nil, err
	}

	// 手动实现，根据assistanceRequest中的status_id查询AssistanceStatus
	var assistanceStatus model.AssistanceStatus
	if err := r.DB.First(&assistanceStatus, assistance.StatusID).Error; err != nil {
		// 处理错误
		return assistance, nil, err
	}
	assistance.AssistanceStatus = assistanceStatus

	// 获取相关的交流记录，并预加载User以获取用户名
	if err := r.DB.Preload("User").Where("request_id = ?", requestID).Find(&responses).Error; err != nil {
		return assistance, nil, err
	}

	return assistance, responses, nil
}

func (r *AssistanceRepository) CreateNewAssistance(assistance *model.AssistanceRequest) (uint, error) {
	// 使用指针传递模型，这样Gorm可以更新模型中的ID字段
	if err := r.DB.Create(assistance).Error; err != nil {
		return 0, err // 返回错误
	}
	return assistance.RequestID, nil // 返回插入行的ID
}

// AdminReplyToAssistance 管理员回复工单
func (r *AssistanceRepository) AdminReplyToAssistance(requestID, responderID uint, responseText string, newStatusID uint) error {
	return r.DB.Transaction(func(tx *gorm.DB) error {
		// 创建新的回复记录
		response := model.AssistanceResponse{
			RequestID:    requestID,
			ResponderID:  responderID,
			ResponseText: responseText,
			CreatedAt:    time.Now(),
		}
		if err := tx.Create(&response).Error; err != nil {
			return err
		}

		// 更新工单状态
		if newStatusID != 0 {
			if err := tx.Model(&model.AssistanceRequest{}).Where("request_id = ?", requestID).Update("status_id", newStatusID).Error; err != nil {
				return err
			}
		}

		return nil
	})
}

// GetAssistanceRequest 获取工单信息
func (r *AssistanceRepository) GetAssistanceRequest(requestID uint) (*model.AssistanceRequest, error) {
	var request model.AssistanceRequest
	err := r.DB.Preload("AssistanceStatus").First(&request, requestID).Error
	return &request, err
}

// ReplyToAssistance 用户回复工单
func (r *AssistanceRepository) ReplyToAssistance(requestID uint, userID uint, responseText string) error {
	return r.DB.Transaction(func(tx *gorm.DB) error {
		// 验证工单发起人
		var assistanceRequest model.AssistanceRequest
		if err := tx.Where("request_id = ?", requestID).First(&assistanceRequest).Error; err != nil {
			return err
		}

		// 验证工单是否属于该用户
		if assistanceRequest.MemberID != userID {
			return errors.New("user is not the owner of the assistance request")
		}

		// 验证工单状态
		if assistanceRequest.StatusID == 4 {
			return errors.New("cannot reply to a closed assistance request")
		}

		// 创建回复记录
		response := model.AssistanceResponse{
			RequestID:    requestID,
			ResponderID:  userID,
			ResponseText: responseText,
			CreatedAt:    time.Now(),
		}

		if err := tx.Create(&response).Error; err != nil {
			return err
		}

		// 更新工单状态
		if err := tx.Model(&model.AssistanceRequest{}).Where("request_id = ?", requestID).Update("status_id", 1).Error; err != nil {
			return err
		}

		return nil
	})
}

func (r *AssistanceRepository) CloseAssistanceRequest(requestID uint, userID uint) error {
	// 验证工单是否属于该用户
	var assistanceRequest model.AssistanceRequest
	err := r.DB.Where("request_id = ?", requestID).First(&assistanceRequest).Error
	if err != nil {
		return err
	}

	if assistanceRequest.MemberID != userID {
		return errors.New("unauthorized to close this assistance request")
	}

	// 更新状态为“已关闭”
	return r.DB.Model(&assistanceRequest).Update("status_id", 4).Error
}

// GetAssistanceType 获取工单类型
func (r *AssistanceRepository) GetAssistanceType() ([]domain.AssistanceType, error) {
	var assistanceTypes []domain.AssistanceType
	result := r.DB.Find(&assistanceTypes)
	if result.Error != nil {
		return nil, result.Error
	}
	return assistanceTypes, nil
}

func (r *AssistanceRepository) GetMyAssistances(memberID uint, pageSize uint, pageNum uint) ([]model.AssistanceRequest, uint, error) {
	var assistances []model.AssistanceRequest
	var total int64
	offset := (pageNum - 1) * pageSize

	// 计算总数
	countResult := r.DB.Model(&model.AssistanceRequest{}).Where("member_id = ?", memberID).Count(&total)
	if countResult.Error != nil {
		return nil, 0, countResult.Error
	}

	// 获取数据
	result := r.DB.Preload("AssistanceType").Preload("AssistanceStatus").Where("member_id = ?", memberID).Offset(int(offset)).Limit(int(pageSize)).Find(&assistances)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	return assistances, uint(total), nil
}

// GetAssistanceStatus 获取工单状态
func (r *AssistanceRepository) GetAssistanceStatus() ([]model.AssistanceStatus, error) {
	var assistanceStatus []model.AssistanceStatus
	result := r.DB.Find(&assistanceStatus)
	if result.Error != nil {
		return nil, result.Error
	}
	return assistanceStatus, nil
}

func (r *AssistanceRepository) GetAssistanceCountByStatus(memberID uint, statusID uint) (uint, error) {
	var count int64
	result := r.DB.Model(&model.AssistanceRequest{}).
		Where("member_id = ? AND status_id = ?", memberID, statusID).
		Count(&count)
	return uint(count), result.Error
}
