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

func (s *AssistanceService) GetAssistanceList(form dto.GetAssistanceListRequest) (dto.GetAssistanceListResponse, error) {
	return s.Repo.GetAssistanceList(form)
}

func (s *AssistanceService) ViewAssistance(requestID uint) (model.AssistanceRequest, []model.AssistanceResponse, error) {
	return s.Repo.ViewAssistance(requestID)
}

func (s *AssistanceService) ReplyAssistance(requestID, responderID uint, responseText string, newStatusID uint) error {
	// 检查工单状态
	var assistance model.AssistanceRequest
	if err := s.Repo.DB.Preload("AssistanceStatus").First(&assistance, requestID).Error; err != nil {
		return err
	}

	// 检查工单是否已关闭
	closedStatusID := uint(4) // closedStatusID = 4 表示“已关闭”的状态ID
	if assistance.StatusID == closedStatusID {
		return errors.New("cannot reply to a closed assistance request")
	}

	// 创建新的回复记录
	response := model.AssistanceResponse{
		RequestID:    requestID,
		ResponderID:  responderID,
		ResponseText: responseText,
		CreatedAt:    time.Now(),
	}
	if err := s.Repo.DB.Create(&response).Error; err != nil {
		return err
	}

	// 更新工单状态
	if newStatusID != 0 {
		assistance.StatusID = newStatusID
		if err := s.Repo.DB.Save(&assistance).Error; err != nil {
			return err
		}
	}

	return nil
}
