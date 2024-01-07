package repository

import (
	"gorm.io/gorm"
	"union-system/internal/dto"
	"union-system/internal/model"
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
	dataQuery := r.DB.Model(&model.AssistanceRequest{}).Preload("AssistanceType")
	if form.ID != 0 {
		dataQuery = dataQuery.Where("request_id = ?", form.ID)
	}
	if form.AssistanceTypeId != 0 {
		dataQuery = dataQuery.Where("type_id = ?", form.AssistanceTypeId)
	}

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
			Title:          assistance.Description,
			Status:         assistance.StatusID,
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
	if err := r.DB.Preload("AssistanceType").Preload("AssistanceStatus").First(&assistance, requestID).Error; err != nil {
		return assistance, nil, err
	}

	// 获取相关的交流记录
	if err := r.DB.Where("request_id = ?", requestID).Find(&responses).Error; err != nil {
		return assistance, nil, err
	}

	return assistance, responses, nil
}
