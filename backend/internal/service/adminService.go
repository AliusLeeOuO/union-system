package service

import (
	"union-system/internal/dto"
	"union-system/internal/repository"
	"union-system/utils/password_crypt"
)

type AdminService struct {
	Repo *repository.AdminRepository
}

func NewAdminService(repo *repository.AdminRepository) *AdminService {
	return &AdminService{Repo: repo}
}

func (s *AdminService) UpdateUser(userID uint, req dto.UpdateUserRequest) error {
	// 准备更新数据
	updateData := map[string]interface{}{
		"username":     req.Username,
		"email":        req.Email,
		"phone_number": req.Phone,
		"is_active":    req.Status,
	}

	// 如果提供了密码，则更新密码字段
	if req.Password != nil {
		hash, err := password_crypt.PasswordHash(*req.Password)
		if err != nil {
			return err
		}
		updateData["password"] = hash
	}

	// 调用 Repository 层执行更新操作
	return s.Repo.UpdateUser(userID, updateData)
}
