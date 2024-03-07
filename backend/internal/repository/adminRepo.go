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

// AddLogLogin 方法现在接受单独的参数来插入记录
func (repo *AdminRepository) AddLogLogin(ua string, ip string, loginStatus bool, username string) error {
	i := model.LogLogin{
		UA:          ua,
		IP:          ip,
		LoginStatus: loginStatus,
		Username:    username,
	}

	result := repo.DB.Omit("login_time").Create(&i)
	return result.Error
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
