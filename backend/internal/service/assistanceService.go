package service

import (
	"errors"
	"time"
	"union-system/internal/dto"
	"union-system/internal/dto/dto_admin"
	"union-system/internal/model"
	"union-system/internal/repository"
)

type AssistanceService struct {
	Repo *repository.AssistanceRepository
}

func NewAssistanceService(repo *repository.AssistanceRepository) *AssistanceService {
	return &AssistanceService{Repo: repo}
}

func (s *AssistanceService) GetAssistanceList(form dto.GetAssistanceListRequest) (dto.GetAssistanceListResponse, error) {
	return s.Repo.GetAssistanceList(form)
}

func (s *AssistanceService) ViewAssistance(requestID uint) (model.AssistanceRequest, []model.AssistanceResponse, error) {
	return s.Repo.ViewAssistance(requestID)
}

func (s *AssistanceService) ReplyAssistance(request dto_admin.ReplyAssistanceRequest) error {
	// 检查工单状态
	var assistance model.AssistanceRequest
	if err := s.Repo.DB.First(&assistance, request.RequestID).Error; err != nil {
		return err
	}

	// 检查工单是否已关闭
	if assistance.StatusID == 4 { // closedStatusID = 4 表示“已关闭”的状态ID
		return errors.New("cannot reply to a closed assistance request")
	}

	// 创建新的回复记录
	response := model.AssistanceResponse{
		RequestID:    request.RequestID,
		ResponderID:  request.ResponderID,
		ResponseText: request.ResponseText,
		CreatedAt:    time.Now(),
	}
	if err := s.Repo.DB.Create(&response).Error; err != nil {
		return err
	}

	// 更新工单状态
	if request.NewStatusID != 0 {
		assistance.StatusID = request.NewStatusID
		if err := s.Repo.DB.Save(&assistance).Error; err != nil {
			return err
		}
	}

	return nil
}
