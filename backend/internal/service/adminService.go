package service

import (
	"union-system/internal/repository"
)

type AdminService struct {
	Repo *repository.AdminRepository
}

func NewAdminService(repo *repository.AdminRepository) *AdminService {
	return &AdminService{Repo: repo}
}
