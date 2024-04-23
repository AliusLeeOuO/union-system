package service

import (
	"context"
	"fmt"
	"strconv"
	"time"
	"union-system/global"
	dto "union-system/internal/application/dto"
	"union-system/internal/infrastructure/repository"
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

// GetCPUInfo 从Redis获取CPU信息
func (s *AdminService) GetCPUInfo() (*dto.CPUInfo, error) {
	ctx := context.Background()
	result, err := global.RedisClient.HGetAll(ctx, "cpu_info").Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get cpu_info: %v", err)
	}

	// 解析字段到CPUInfo结构体
	cores, err := strconv.ParseUint(result["cores"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse cpu cores: %v", err)
	}
	trends, err := strconv.ParseUint(result["trends"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse trends: %v", err)
	}
	cache, err := strconv.ParseUint(result["cache"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse cache: %v", err)
	}
	usage, err := strconv.ParseFloat(result["usage"], 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse usage: %v", err)
	}
	idle, err := strconv.ParseFloat(result["idle"], 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse idle: %v", err)
	}
	cpuInfo := &dto.CPUInfo{
		Model:  result["models"],
		Cores:  uint(cores),
		Trends: uint(trends),
		Cache:  uint(cache),
		Usage:  usage,
		Idle:   idle,
	}

	return cpuInfo, nil
}

// GetMemoryInfo 从Redis获取内存信息
func (s *AdminService) GetMemoryInfo() (*dto.MemoryInfo, error) {
	ctx := context.Background()
	result, err := global.RedisClient.HGetAll(ctx, "memory_info").Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get memory_info: %v", err)
	}

	total, err := strconv.ParseUint(result["total"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem total: %v", err)
	}
	used, err := strconv.ParseUint(result["used"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem used: %v", err)
	}
	free, err := strconv.ParseUint(result["free"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem free: %v", err)
	}
	usage, err := strconv.ParseFloat(result["usage"], 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem usage: %v", err)
	}

	// 直接将结果映射到MemoryInfo结构体
	memoryInfo := &dto.MemoryInfo{
		Total: uint(total),
		Used:  uint(used),
		Free:  uint(free),
		Usage: usage,
	}

	return memoryInfo, nil
}

// GetLogAdminsByPage 获取管理员操作日志的分页数据
func (s *AdminService) GetLogAdminsByPage(pageSize, pageNum uint) ([]dto.GetAdminLogResponse, uint, error) {
	logs, total, err := s.Repo.GetLogAdminsByPage(pageSize, pageNum)
	var logResponses []dto.GetAdminLogResponse
	for _, log := range logs {
		logResponses = append(logResponses, dto.GetAdminLogResponse{
			LogId: log.LogID,
			User: struct {
				ID       uint   `json:"id"`
				Username string `json:"username"`
			}(struct {
				ID       uint
				Username string
			}{ID: log.UserId, Username: log.Username}),
			Action: struct {
				ID   uint   `json:"id"`
				Name string `json:"name"`
			}{ID: log.ModuleID, Name: log.ActionName},
			Detail: log.ActionDetail,
			IP:     log.IP,
			Time:   log.ActionTime.Format(time.RFC3339),
		})
	}

	return logResponses, total, err
}

// GetLogMembersByPage 获取会员操作日志的分页数据
func (s *AdminService) GetLogMembersByPage(pageSize, pageNum uint) ([]dto.GetMemberLogResponse, uint, error) {
	logs, total, err := s.Repo.GetLogMembersByPage(pageSize, pageNum)
	var logResponses []dto.GetMemberLogResponse
	for _, log := range logs {
		logResponses = append(logResponses, dto.GetMemberLogResponse{
			LogId: log.LogID,
			User: struct {
				ID       uint   `json:"id"`
				Username string `json:"username"`
			}{ID: log.UserID, Username: log.Username},
			Action: struct {
				ID   uint   `json:"id"`
				Name string `json:"name"`
			}{ID: log.ModuleId, Name: log.ActionName},
			Detail: log.ActionDetail,
			IP:     log.Ip,
			Time:   log.ActionTime.Format(time.RFC3339),
		})
	}

	return logResponses, total, err
}
