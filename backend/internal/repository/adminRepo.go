package repository

import (
	"gorm.io/gorm"
	"union-system/internal/model"
)

type AdminRepository struct {
	DB *gorm.DB
}

func NewAdminRepository(db *gorm.DB) *AdminRepository {
	return &AdminRepository{DB: db}
}

func (repo *AdminRepository) UpdateUser(userID uint, updateData map[string]interface{}) error {
	// 执行更新操作
	if err := repo.DB.Model(&model.User{}).Where("user_id = ?", userID).Updates(updateData).Error; err != nil {
		return err
	}
	return nil
}

// FindLogLoginsByPage 分页查询登录日志，根据status筛选，并按login_time倒序
func (repo *AdminRepository) FindLogLoginsByPage(pageSize, pageNum uint, status string) ([]model.LogLogin, uint, error) {
	var logs []model.LogLogin
	var total int64

	offset := (pageNum - 1) * pageSize
	query := repo.DB.Model(&model.LogLogin{}) // 初始化查询

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
	model.LogAdmin        // 嵌入原始 LogAdmin 结构体
	Username       string `gorm:"column:username"`    // 用户名
	ActionName     string `gorm:"column:action_name"` // 动作名称
}

// GetLogAdminsByPage 分页查询管理员操作日志
func (repo *AdminRepository) GetLogAdminsByPage(pageSize, pageNum uint) ([]AdminLogWithDetails, uint, error) {
	var logs []AdminLogWithDetails
	var total int64

	offset := (pageNum - 1) * pageSize
	result := repo.DB.Table("tb_log_admin").
		Select("tb_log_admin.*, tb_user.username as username, tb_log_modules.module_name as action_name").
		Joins("left join tb_user on tb_user.user_id = tb_log_admin.user_id").
		Joins("left join tb_log_modules on tb_log_modules.module_id = tb_log_admin.module_id").
		Order("action_time DESC").Offset(int(offset)).Limit(int(pageSize)).
		Count(&total).Find(&logs)

	if result.Error != nil {
		return nil, 0, result.Error
	}

	return logs, uint(total), nil
}
