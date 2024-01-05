package repository

import (
	"gorm.io/gorm"
	"union-system/global"
	"union-system/internal/model"
	"union-system/utils/password_crypt"
)

// UserRepository DDD设计模式 实验性代码
type UserRepository struct {
	DB *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (repo *UserRepository) GetAdminUsers(page int, pageSize int, username string, userId uint, userRole uint) ([]model.User, error) {
	var users []model.User
	offset := (page - 1) * pageSize

	dbInstance := repo.DB.Omit("Password").Offset(offset).Limit(pageSize)
	if username != "" {
		dbInstance = dbInstance.Where("username LIKE ?", "%"+username+"%")
	}
	if userId != 0 {
		dbInstance = dbInstance.Where("id = ?", userId)
	}
	if userRole != 0 {
		dbInstance = dbInstance.Where("role = ?", userRole)
	}

	result := dbInstance.Find(&users)

	if result.Error != nil {
		return nil, result.Error
	}
	return users, nil
}

func (repo *UserRepository) GetUserByUsername(username string) (*model.User, error) {
	var user model.User
	result := repo.DB.Where("username = ?", username).First(&user)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}

func (repo *UserRepository) GetUserByID(userID uint) (*model.User, error) {
	var user model.User
	result := repo.DB.First(&user, userID)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}

func (repo *UserRepository) CheckUserPassword(userID uint, password string) bool {
	var user model.User
	result := repo.DB.First(&user, userID)
	if result.Error != nil {
		return false
	}

	return password_crypt.PasswordVerify(password, user.Password)
}

func (repo *UserRepository) ChangePasswordByID(userID uint, newPassword string) error {
	var user model.User
	result := repo.DB.First(&user, userID)
	if result.Error != nil {
		return result.Error
	}

	// 加密密码
	hashedPassword, err := password_crypt.PasswordHash(newPassword)
	if err != nil {
		return err
	}

	// 更新密码
	result = global.Database.Model(&user).Update("password", hashedPassword)
	if result.Error != nil {
		return result.Error
	}

	return nil
}
