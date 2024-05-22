package service

import (
	"context"
	"fmt"
	"strconv"
	"time"
	"union-system/global"
	dto "union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
	"union-system/utils/build_permission_tree"
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
		"user_type_id": req.PermissionGroup,
	}

	// 先检查user_type_id是否被允许
	permissions, err := s.GetAllowPermissionsByUserID(userID)
	if err != nil {
		return err
	}
	allowed := false
	for _, p := range permissions {
		if p.TypeID == req.PermissionGroup {
			allowed = true
			break
		}
	}
	if !allowed {
		return fmt.Errorf("权限组%d不被允许", req.PermissionGroup)
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

// GetAllowPermissionsByUserID 获取用户的权限列表
func (s *AdminService) GetAllowPermissionsByUserID(userID uint) ([]domain.UserType, error) {
	// 先获取用户的角色user_role
	userRole, err := s.Repo.GetUserRoleByUserID(userID)
	if err != nil {
		return nil, err
	}
	// 根据角色获取权限列表
	permissions, err := s.Repo.GetPermissionsByRole(userRole)
	if err != nil {
		return nil, err
	}
	return permissions, nil
}

// GetAllowPermissionsByUserType 获取用户类型的权限列表
func (s *AdminService) GetAllowPermissionsByUserType(userType string) ([]domain.UserType, error) {
	// 根据角色获取权限列表
	permissions, err := s.Repo.GetPermissionsByRole(userType)
	if err != nil {
		return nil, err
	}
	return permissions, nil
}

func (s *AdminService) GetPermissions(userType uint) ([]*build_permission_tree.PermissionNode, error) {
	// 如果userType为0，返回所有权限
	if userType == 0 {
		permissions, err := s.Repo.GetPermissions()
		if err != nil {
			return nil, err
		}
		permissionTree := build_permission_tree.BuildPermissionTree(permissions)
		return permissionTree, nil
	}

	// 然后根据角色查询权限，先查询角色权限表
	rolePermissions, err := s.Repo.GetRolePermissions(userType)
	// 如果查询不到，返回空
	if err != nil {
		return nil, err
	}
	// 如果查询到，根据权限ID查询权限表
	// 传入权限ID数组，查询权限表
	permissions, err := s.Repo.GetPermissionsByIDs(rolePermissions)
	// 如果查询不到，返回空
	if err != nil {
		return nil, err
	}
	permissionTree := build_permission_tree.BuildPermissionTree(permissions)
	// 如果查询到，返回权限列表
	return permissionTree, nil
}

// NewPermissionNode 新增权限节点
func (s *AdminService) NewPermissionNode(parentNode uint, permissionNode, description, permissionType string, permissionName string, listOrder uint, listHidden bool) error {
	return s.Repo.NewPermissionNode(parentNode, permissionNode, description, permissionType, permissionName, listOrder, listHidden)
}

// DeletePermissionNode 删除权限节点
func (s *AdminService) DeletePermissionNode(nodeID uint) error {
	return s.Repo.DeletePermissionNode(nodeID)
}

// AddPermissionGroup 新增权限组
func (s *AdminService) AddPermissionGroup(typeName, description, allowRoleType string) error {
	return s.Repo.AddPermissionGroup(typeName, description, allowRoleType)
}

// DeletePermissionGroup 删除权限组
func (s *AdminService) DeletePermissionGroup(groupID uint) error {
	// 先检查是否有用户使用该权限组
	users, err := s.Repo.GetUsersByPermissionGroup(groupID)
	if err != nil {
		return err
	}
	if len(users) > 0 {
		return fmt.Errorf("该权限组下有用户，无法删除")
	}
	return s.Repo.DeletePermissionGroup(groupID)
}

// GetPermissionNodeByType 根据权限类型获取权限节点
func (s *AdminService) GetPermissionNodeByType(permissionType string) ([]*build_permission_tree.PermissionNode, error) {
	permissions, err := s.Repo.GetPermissionNodeByType(permissionType)
	if err != nil {
		return nil, err
	}
	// 组装成树形结构
	permissionTree := build_permission_tree.BuildPermissionTree(permissions)
	return permissionTree, nil
}

// ModifyGroupPermissions 修改权限组的权限
func (s *AdminService) ModifyGroupPermissions(permissionIDs []uint, groupID uint) error {
	// 先使用groupID查询用户角色
	role, err := s.Repo.GetRoleByGroupID(groupID)
	// 如果查询不到，返回错误
	if err != nil {
		return err
	}
	// 然后使用permissionIDs查询权限表
	permissions, err := s.Repo.GetPermissionsByIDs(permissionIDs)
	// 如果查询不到，返回错误
	if err != nil {
		return err
	}
	// 然后查询现有的权限
	rolePermissions, err := s.Repo.GetRolePermissions(groupID)
	// 如果查询不到，返回错误
	if err != nil {
		return err
	}
	// 然后比较现有的权限和新的权限
	// 如果新的权限在现有的权限中，不做任何操作
	// 如果新的权限不在现有的权限中，插入新的权限
	// 收集需要删除和需要插入的权限
	var toDelete []uint
	var toInsert []uint
	for _, p := range permissions {
		found := false
		for _, rp := range rolePermissions {
			if p.PermissionID == rp {
				found = true
				break
			}
		}
		if !found {
			toInsert = append(toInsert, p.PermissionID)
		}
	}
	for _, rp := range rolePermissions {
		found := false
		for _, p := range permissions {
			if p.PermissionID == rp {
				found = true
				break
			}
		}
		if !found {
			toDelete = append(toDelete, rp)
		}
	}
	// 然后插入需要插入的权限，传入权限ID数组给Repository层
	// 先使用role查询所有允许的权限
	allowPermissions, err := s.Repo.GetPermissionNodeByType(role)
	if err != nil {
		return err
	}
	// 然后检查是否有权限不在允许的权限中
	for _, p := range toInsert {
		found := false
		for _, ap := range allowPermissions {
			if p == ap.PermissionID {
				found = true
				break
			}
		}
		if !found {
			return fmt.Errorf("权限%d不被允许", p)
		}
	}

	// 然后删除需要删除的权限，传入权限ID数组给Repository层
	if len(toDelete) > 0 {
		if err = s.Repo.DeleteRolePermissions(groupID, toDelete); err != nil {
			return err
		}
	}

	if len(toInsert) > 0 {
		if err = s.Repo.InsertRolePermissions(groupID, toInsert); err != nil {
			return err
		}
	}

	return nil
}
