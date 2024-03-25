package service

import (
	"context"
	"fmt"
	"strconv"
	"time"
	"union-system/global"
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

// 从Redis获取CPU信息
func GetCPUInfo() (*dto.CPUInfo, error) {
	ctx := context.Background()
	result, err := global.RedisClient.HGetAll(ctx, "cpu_info").Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get cpu_info: %v", err)
	}

	// 解析字段到CPUInfo结构体
	cores, err := strconv.Atoi(result["cores"])
	if err != nil {
		return nil, fmt.Errorf("failed to parse cpu cores: %v", err)
	}
	cache, err := strconv.Atoi(result["cache"])
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
		Model: result["model"],
		Cores: uint(cores),
		Cache: uint(cache),
		Usage: usage,
		Idle:  idle,
	}

	return cpuInfo, nil
}

// 从Redis获取内存信息
func GetMemoryInfo() (*dto.MemoryInfo, error) {
	ctx := context.Background()
	result, err := global.RedisClient.HGetAll(ctx, "memory_info").Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get memory_info: %v", err)
	}

	total, err := strconv.ParseUint(result["cores"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem total: %v", err)
	}
	used, err := strconv.ParseUint(result["cores"], 10, 64)
	if err != nil {
		return nil, fmt.Errorf("failed to parse mem total: %v", err)
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
