package service

import (
	"time"
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

// AddLogLoginService 现在接受单独的参数，并将它们传递到repository的AddLogLogin方法
func (s *AdminService) AddLogLoginService(ua string, ip string, loginStatus bool, username string) error {
	return s.Repo.AddLogLogin(ua, ip, loginStatus, username)
}

// GetLogLoginsByPage 获取登录日志的分页数据
func (s *AdminService) GetLogLoginsByPage(pageSize, pageNum uint, status string) ([]dto.GetLoginLogResponse, uint, error) {
	logs, total, err := s.Repo.FindLogLoginsByPage(pageSize, pageNum, status)
	var logResponses []dto.GetLoginLogResponse
	for _, log := range logs {
		logResponses = append(logResponses, dto.GetLoginLogResponse{
			LogId:     log.LogID,
			UA:        log.UA,
			IP:        log.IP,
			LoginTime: log.LoginTime.Format(time.RFC3339),
			Username:  log.Username,
			Status:    log.LoginStatus,
		})
	}
	return logResponses, total, err
}
