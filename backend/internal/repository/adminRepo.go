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

func (repo *AdminRepository) GetAssistanceType() ([]model.AssistanceType, error) {
	var assistanceTypes []model.AssistanceType
	result := repo.DB.Find(&assistanceTypes)
	if result.Error != nil {
		return nil, result.Error
	}
	return assistanceTypes, nil
}
