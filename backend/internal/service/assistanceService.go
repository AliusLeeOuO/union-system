package service

import (
	"union-system/internal/dto"
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
