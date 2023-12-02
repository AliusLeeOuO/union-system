package repository

import (
	"union-system/global"
	"union-system/internal/model"
	"union-system/utils/password_crypt"
)

// CheckCredentials 查询数据库以验证用户名和密码
func CheckCredentials(username, password string) (*model.TbUser, bool) {
	var user model.TbUser

	//result := global.Database.Where("username = ? AND password = ?", username, password).First(&user)
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
