package repository

import (
	"gorm.io/gorm"
	"union-system/internal/domain"
)

type AdminRepository struct {
	DB *gorm.DB
}

func NewAdminRepository(db *gorm.DB) *AdminRepository {
	return &AdminRepository{DB: db}
}

func (repo *AdminRepository) UpdateUser(userID uint, updateData map[string]interface{}) error {
	// 执行更新操作
	if err := repo.DB.Model(&domain.User{}).Where("user_id = ?", userID).Updates(updateData).Error; err != nil {
		return err
	}
	return nil
}

// FindLogLoginsByPage 分页查询登录日志，根据status筛选，并按login_time倒序
func (repo *AdminRepository) FindLogLoginsByPage(pageSize, pageNum uint, status string) ([]domain.LogLogin, uint, error) {
	var logs []domain.LogLogin
	var total int64

	offset := (pageNum - 1) * pageSize
	query := repo.DB.Model(&domain.LogLogin{}) // 初始化查询

	// 根据status参数添加条件
	if status == "true" || status == "false" {
		query = query.Where("login_status = ?", status == "true")
	}

	// 首先统计总数
	result := query.Count(&total)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 然后根据分页参数并按login_time倒序查询记录
	result = query.Order("login_time DESC").Offset(int(offset)).Limit(int(pageSize)).Find(&logs)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	return logs, uint(total), nil
}

// AdminLogWithDetails 包含日志信息，用户名称和动作名称
type AdminLogWithDetails struct {
	domain.LogAdmin        // 嵌入原始 LogAdmin 结构体
	Username        string `gorm:"column:username"`    // 用户名
	ActionName      string `gorm:"column:action_name"` // 动作名称
}

// GetLogAdminsByPage 分页查询管理员操作日志
func (repo *AdminRepository) GetLogAdminsByPage(pageSize, pageNum uint) ([]AdminLogWithDetails, uint, error) {
	var logs []AdminLogWithDetails
	var total int64

	offset := (pageNum - 1) * pageSize

	// First, count the total number of records
	countResult := repo.DB.Table("tb_log_admin").
		Joins("left join tb_user on tb_user.user_id = tb_log_admin.user_id").
		Joins("left join tb_log_modules on tb_log_modules.module_id = tb_log_admin.module_id").
		Count(&total)

	if countResult.Error != nil {
		return nil, 0, countResult.Error
	}

	// Then, get the data
	dataResult := repo.DB.Table("tb_log_admin").
		Select("tb_log_admin.*, tb_user.username as username, tb_log_modules.module_name as action_name").
		Joins("left join tb_user on tb_user.user_id = tb_log_admin.user_id").
		Joins("left join tb_log_modules on tb_log_modules.module_id = tb_log_admin.module_id").
		Order("action_time DESC").Offset(int(offset)).Limit(int(pageSize)).
		Find(&logs)

	if dataResult.Error != nil {
		return nil, 0, dataResult.Error
	}

	return logs, uint(total), nil
}

type MemberLogWithDetails struct {
	domain.LogMember
	Username   string `gorm:"column:username"`
	ActionName string `gorm:"column:action_name"`
}

// GetLogMembersByPage 分页查询会员操作日志
func (repo *AdminRepository) GetLogMembersByPage(pageSize, pageNum uint) ([]MemberLogWithDetails, uint, error) {
	var logs []MemberLogWithDetails
	var total int64

	offset := (pageNum - 1) * pageSize

	// First, count the total number of records
	countResult := repo.DB.Table("tb_log_member").
		Joins("left join tb_user on tb_user.user_id = tb_log_member.user_id").
		Joins("left join tb_log_modules on tb_log_modules.module_id = tb_log_member.module_id").
		Count(&total)

	if countResult.Error != nil {
		return nil, 0, countResult.Error
	}

	// Then, get the data
	dataResult := repo.DB.Table("tb_log_member").
		Select("tb_log_member.*, tb_user.username as username, tb_log_modules.module_name as action_name").
		Joins("left join tb_user on tb_user.user_id = tb_log_member.user_id").
		Joins("left join tb_log_modules on tb_log_modules.module_id = tb_log_member.module_id").
		Order("action_time DESC").Offset(int(offset)).Limit(int(pageSize)).
		Find(&logs)

	if dataResult.Error != nil {
		return nil, 0, dataResult.Error
	}

	return logs, uint(total), nil
}

// GetUserRoleByUserID 根据用户ID获取用户的角色
func (repo *AdminRepository) GetUserRoleByUserID(userID uint) (string, error) {
	var user domain.User
	if err := repo.DB.Model(&domain.User{}).Select("user_role").Where("user_id = ?", userID).First(&user).Error; err != nil {
		return "", err
	}
	return user.UserRole, nil
}

// GetPermissionsByRole 根据角色获取权限列表
func (repo *AdminRepository) GetPermissionsByRole(role string) ([]domain.UserType, error) {
	var permissions []domain.UserType
	if err := repo.DB.Model(&domain.UserType{}).Select("type_id, description").Where("allow_account_type = ?", role).Find(&permissions).Error; err != nil {
		return nil, err
	}
	return permissions, nil
}

// GetRolePermissionsByPermissionID 根据权限ID获取角色列表
func (repo *AdminRepository) GetRolePermissionsByPermissionID(roleID uint) ([]domain.RolePermission, error) {
	var rolePermissions []domain.RolePermission
	if err := repo.DB.Model(&domain.RolePermission{}).Where("role_id = ?", roleID).Find(&rolePermissions).Error; err != nil {
		return nil, err
	}
	return rolePermissions, nil
}

// GetRolePermissions 获取角色的权限关联ID
func (repo *AdminRepository) GetRolePermissions(roleID uint) ([]uint, error) {
	var permissions []uint
	result := repo.DB.Model(&domain.RolePermission{}).Where("role_id = ?", roleID).Pluck("permission_id", &permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// GetPermissions 获取所有权限
func (repo *AdminRepository) GetPermissions() ([]domain.Permission, error) {
	var permissions []domain.Permission
	result := repo.DB.Where("del_flag", false).Find(&permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// GetPermissionsByIDs 根据权限ID获取权限
func (repo *AdminRepository) GetPermissionsByIDs(permissionIDs []uint) ([]domain.Permission, error) {
	var permissions []domain.Permission
	result := repo.DB.Where("permission_id IN ? AND del_flag = ?", permissionIDs, false).Order("list_order ASC").Find(&permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// NewPermissionNode 新增权限节点
func (repo *AdminRepository) NewPermissionNode(parentNode uint, permissionNode, description, permissionType string, permissionName string, listOrder uint, listHidden bool) error {
	permission := domain.Permission{
		ParentPermissionID: parentNode,
		PermissionNode:     permissionNode,
		RoleType:           permissionType,
		Description:        description,
		PermissionName:     permissionName,
		ListOrder:          listOrder,
		ListHidden:         listHidden,
		Icon:               "IconApps",
	}
	if err := repo.DB.Omit("permission_id", "del_flag", "gmt_create").Create(&permission).Error; err != nil {
		return err
	}
	return nil
}

// DeletePermissionNode 删除权限节点
func (repo *AdminRepository) DeletePermissionNode(nodeID uint) error {
	// 将del_flag字段设置为1，表示删除
	if err := repo.DB.Model(&domain.Permission{}).Where("permission_id = ?", nodeID).Update("del_flag", true).Error; err != nil {
		return err
	}
	return nil
}

// AddPermissionGroup 新增权限组
func (repo *AdminRepository) AddPermissionGroup(typeName, description, allowRoleType string) error {
	permission := domain.UserType{
		TypeName:         typeName,
		Description:      description,
		AllowAccountType: allowRoleType,
	}
	if err := repo.DB.Omit("type_id", "del_flag", "gmt_create").Create(&permission).Error; err != nil {
		return err
	}
	return nil
}

// GetUsersByPermissionGroup 根据权限组获取用户列表
func (repo *AdminRepository) GetUsersByPermissionGroup(roleID uint) ([]domain.User, error) {
	var users []domain.User
	result := repo.DB.Model(&domain.User{}).Where("user_type_id = ?", roleID).Find(&users)
	if result.Error != nil {
		return nil, result.Error
	}
	return users, nil
}

// DeletePermissionGroup 删除权限组
func (repo *AdminRepository) DeletePermissionGroup(groupID uint) error {
	// 直接删除
	if err := repo.DB.Where("type_id = ?", groupID).Delete(&domain.UserType{}).Error; err != nil {
		return err
	}
	return nil
}

// GetPermissionNodeByType 根据权限类型获取权限节点
func (repo *AdminRepository) GetPermissionNodeByType(permissionType string) ([]domain.Permission, error) {
	var permissions []domain.Permission
	result := repo.DB.Where("for_type = ? AND del_flag = ?", permissionType, false).Order("list_order ASC").Find(&permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// GetRoleByGroupID 根据权限组ID获取角色
func (repo *AdminRepository) GetRoleByGroupID(groupID uint) (string, error) {
	var role domain.UserType
	result := repo.DB.Model(&domain.UserType{}).Select("allow_account_type").Where("type_id = ?", groupID).First(&role)
	if result.Error != nil {
		return "", result.Error
	}
	return role.AllowAccountType, nil
}

// DeleteRolePermissions 删除角色的权限 GroupID 和 PermissionID数组
func (repo *AdminRepository) DeleteRolePermissions(groupID uint, permissionIDs []uint) error {
	result := repo.DB.Where("role_id = ? AND permission_id IN ?", groupID, permissionIDs).Delete(&domain.RolePermission{})
	if result.Error != nil {
		return result.Error
	}
	return nil
}

// InsertRolePermissions 添加角色的权限 GroupID 和 PermissionID数组
func (repo *AdminRepository) InsertRolePermissions(groupID uint, permissionIDs []uint) error {
	var rolePermissions []domain.RolePermission
	for _, permissionID := range permissionIDs {
		rolePermissions = append(rolePermissions, domain.RolePermission{
			RoleId:       groupID,
			PermissionId: permissionID,
		})
	}
	result := repo.DB.Create(&rolePermissions)
	if result.Error != nil {
		return result.Error
	}
	return nil
}
