package repository

import (
	"union-system/global"
	"union-system/internal/model"
	"union-system/utils/password_crypt"
)

// CheckCredentials 查询数据库以验证用户名和密码
func CheckCredentials(username, password string) (*model.TbUser, bool) {
	var user model.TbUser

	result := global.Database.Where("username = ?", username).First(&user)

	// 校验密码
	if !password_crypt.PasswordVerify(password, user.Password) {
		return nil, false
	}

	// 检查是否有匹配记录且没有错误
	if result.Error == nil && result.RowsAffected == 1 {
		return &user, true
	}
	return nil, false
}

func GetUserByID(userID uint) (*model.TbUser, error) {
	var user model.TbUser
	result := global.Database.First(&user, userID)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}

func ChangePasswordByID(userID uint, newPassword string) error {
	var user model.TbUser
	result := global.Database.First(&user, userID)
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

func CheckUserPassword(userID uint, password string) bool {
	var user model.TbUser
	result := global.Database.First(&user, userID)
	if result.Error != nil {
		return false
	}

	return password_crypt.PasswordVerify(password, user.Password)
}
