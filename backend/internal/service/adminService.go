package service

import (
	"union-system/internal/dto"
	"union-system/internal/repository"
)

type AdminService struct {
	Repo *repository.AdminRepository
}

func NewAdminService(repo *repository.AdminRepository) *AdminService {
	return &AdminService{Repo: repo}
}

func (s *AdminService) GetAssistanceType() ([]dto.GetAssistanceTypeRequest, error) {
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
