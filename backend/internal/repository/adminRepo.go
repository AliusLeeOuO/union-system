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
