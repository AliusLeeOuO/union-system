package service

import (
	"errors"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/utils/captcha"
	"union-system/utils/jwt"
	"union-system/utils/password_crypt"
)

type UserService struct {
	Repo *repository.UserRepository
}

func NewUserService(repo *repository.UserRepository) *UserService {
	return &UserService{Repo: repo}
}

func (s *UserService) Login(username, password, captchaID, captchaVal string) (*dto.LoginResponse, error) {
	// 验证验证码
	if !captcha.VerifyCode(captchaID, captchaVal) {
		return nil, errors.New("invalid captcha")
	}

	// 验证用户凭据
	user, err := s.Repo.GetUserByUsername(username)
	if err != nil {
		return nil, err
	}

	// 账户状态验证
	if !user.IsActive {
		return nil, errors.New("account is not active")
	}

	// 密码验证逻辑
	if !password_crypt.PasswordVerify(password, user.Password) {
		return nil, errors.New("invalid credentials")
	}

	// 创建 Token 信息
	tokenInfo := jwt.UserInfo{
		Id:       user.UserID,
		Username: user.Username,
		Role:     user.UserTypeID,
	}

	// 生成 Token 字符串
	tokenStr, err := jwt.GenerateToken(tokenInfo)
	if err != nil {
		return nil, err
	}

	responseData := dto.LoginResponse{
		Token:    tokenStr,
		UserId:   user.UserID,
		Username: user.Username,
		Role:     user.UserTypeID,
		Status:   user.IsActive,
	}
	return &responseData, nil
}

func (s *UserService) GetAdminUsers(page int, pageSize int, username string, userId uint, userRole uint) ([]model.User, int64, error) {
	users, err := s.Repo.GetAdminUsers(page, pageSize, username, userId, userRole)
	if err != nil {
		return nil, 0, err
	}

	count, err := s.Repo.CountAdminUsers(username, userId, userRole)
	if err != nil {
		return nil, 0, err
	}

	return users, count, nil
}

func (s *UserService) ChangeUserPassword(userId uint, oldPassword string, newPassword string) error {
	// 验证旧密码
	if !s.Repo.CheckUserPassword(userId, oldPassword) {
		return errors.New("密码验证错误")
	}

	// 修改密码
	err := s.Repo.ChangePasswordByID(userId, newPassword)
	if err != nil {
		return err
	}
	return nil
}

func (s *UserService) GetUserById(userId uint) (*model.User, error) {
	return s.Repo.GetUserByID(userId)
}
