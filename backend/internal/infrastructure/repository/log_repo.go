package repository

import (
	"gorm.io/gorm"
	"union-system/internal/domain"
)

type LogRepository struct {
	DB *gorm.DB
}

func NewLogRepository(db *gorm.DB) *LogRepository {
	return &LogRepository{DB: db}
}

// InsertAdminLog 插入新的管理员操作日志
func (r *LogRepository) InsertAdminLog(log *domain.LogAdmin) error {
	return r.DB.Omit("action_time").Create(log).Error
}

// InsertMemberLog 插入新的会员操作日志
func (r *LogRepository) InsertMemberLog(log *domain.LogMember) error {
	return r.DB.Omit("action_time").Create(log).Error
}

// AddLoginLog 添加新的登录日志
func (r *LogRepository) AddLoginLog(log *domain.LogLogin) error {
	return r.DB.Omit("login_time").Create(&log).Error
}
