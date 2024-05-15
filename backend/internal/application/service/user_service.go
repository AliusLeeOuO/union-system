package service

import (
	"errors"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
	"union-system/utils/build_permission_tree"
	"union-system/utils/captcha"
	"union-system/utils/generate_random_code"
	"union-system/utils/jwt"
	"union-system/utils/password_crypt"
)

type UserService struct {
	Repo *repository.UserRepository
}

func NewUserService(repo *repository.UserRepository) *UserService {
	return &UserService{Repo: repo}
}

func (s *UserService) Login(c *fiber.Ctx, username, password, captchaID, captchaVal string) (*dto.LoginResponse, error) {
	// 验证验证码
	if !captcha.VerifyCode(captchaID, captchaVal) {
		return nil, errors.New("验证码错误")
	}

	// 验证用户凭据
	user, err := s.Repo.GetUserByUsername(username)
	if err != nil {
		return nil, err
	}

	// 账户状态验证
	if !user.IsActive {
		return nil, errors.New("账号已被禁用")
	}

	// 密码验证逻辑
	if !password_crypt.PasswordVerify(password, user.Password) {
		return nil, errors.New("账号或密码错误")
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

	// 保存 Token 到 Redis
	userTokenKey := fmt.Sprintf("user_tokens:%d", responseData.UserId)
	pipe := global.RedisClient.Pipeline()
	pipe.LPush(c.Context(), userTokenKey, responseData.Token)
	pipe.LTrim(c.Context(), userTokenKey, 0, 2) // 保持列表最多 3 个元素
	pipe.Expire(c.Context(), userTokenKey, 24*time.Hour)
	_, err = pipe.Exec(c.Context())
	if err != nil {
		global.Logger.Info("保存 Token 出错", err)
		return nil, errors.New("保存 Token 出错")
	}

	return &responseData, nil
}

func (s *UserService) GetUserList(page int, pageSize int, username string, userId uint, userRole uint) ([]domain.User, int64, error) {
	users, err := s.Repo.GetUsers(page, pageSize, username, userId, userRole)
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
		return errors.New("账号或密码错误")
	}

	// 修改密码
	err := s.Repo.ChangePasswordByID(userId, newPassword)
	if err != nil {
		return err
	}
	return nil
}

func (s *UserService) GetUserById(userId uint) (*domain.User, error) {
	return s.Repo.GetUserByID(userId)
}

func (s *UserService) CreateUser(username, password, email string, role uint, phone string) error {
	// 密码加密
	passwordHash, err := password_crypt.PasswordHash(password)
	if err != nil {
		return err
	}

	// 创建用户
	_, err = s.Repo.CreateUser(username, passwordHash, email, role, phone)
	if err != nil {
		return err
	}
	return nil
}

// VerifyPassword 验证用户密码
func (s *UserService) VerifyPassword(userID uint, password string) (bool, error) {
	return s.Repo.CheckPassword(userID, password)
}

func (s *UserService) RegisterUser(username, password, email, phoneNumber, invitationCodeStr string) error {
	// 验证邀请码
	invitationCode, err := s.Repo.VerifyInvitationCode(invitationCodeStr)
	if err != nil {
		return errors.New("邀请码无效")
	}

	encPassword, err := password_crypt.PasswordHash(password)
	if err != nil {
		return err
	}

	userID, err := s.Repo.CreateUser(username, encPassword, email, 2, phoneNumber)
	if err != nil {
		return err
	}

	// 将邀请码标记为已使用
	err = s.Repo.MarkInvitationCodeAsUsed(invitationCode.CodeID, userID)
	if err != nil {
		// 可能需要回滚创建用户的操作
		return err
	}

	return nil
}

func (s *UserService) GetInvitationCodes(pageNum, pageSize uint) ([]dto.InvitationCodeResponse, uint, error) {
	codes, total, err := s.Repo.GetInvitationCodes(pageNum, pageSize)
	if err != nil {
		return nil, 0, err
	}
	var result []dto.InvitationCodeResponse
	for _, code := range codes {
		result = append(result, dto.InvitationCodeResponse{
			CodeID:          code.CodeID,
			Code:            code.Code,
			CreatedByUserID: code.CreatedByUserID,
			IsUsed:          code.IsUsed,
			CreatedAt:       code.CreatedAt,
			ExpiresAt:       code.ExpiresAt,
		})
		if code.UsedByUserID != nil {
			result[len(result)-1].UsedByUserID = strconv.Itoa(int(*code.UsedByUserID))
		}
	}
	return result, total, nil
}

// GenerateInvitationCode 生成邀请码
func (s *UserService) GenerateInvitationCode(userID uint) (dto.NewInvitationCodeResponse, error) {
	// 生成8位随机字符串作为邀请码
	code := generate_random_code.GenerateRandomCode(8)

	// 准备邀请码记录
	invitationCode := domain.InvitationCodes{
		Code:            code,
		CreatedByUserID: userID,
		IsUsed:          false,
		ExpiresAt:       time.Now().Add(time.Hour * 24 * 7),
	}

	// 保存到数据库
	err := s.Repo.CreateInvitationCode(&invitationCode)
	if err != nil {
		return dto.NewInvitationCodeResponse{}, err
	}

	var result = dto.NewInvitationCodeResponse{
		CodeID:    invitationCode.CodeID,
		Code:      invitationCode.Code,
		CreatedAt: invitationCode.CreatedAt.Format(time.RFC3339),
		ExpiresAt: invitationCode.ExpiresAt.Format(time.RFC3339),
	}

	return result, nil
}

func (s *UserService) GetPermissions(c *fiber.Ctx, userID uint) ([]*build_permission_tree.PermissionNode, error) {
	// 首先查询用户的角色 user_type_id
	user, err := s.Repo.GetUserByID(userID)
	if err != nil {
		return nil, err
	}

	userType := user.UserTypeID
	// 然后根据角色查询权限，先查询角色权限表
	rolePermissions, err := s.Repo.GetRolePermissions(userType)
	// 如果查询不到，返回空
	if err != nil {
		return nil, err
	}
	// 如果查询到，根据权限ID查询权限表
	// 传入权限ID数组，查询权限表
	permissions, err := s.Repo.GetPermissionsByIDs(rolePermissions)
	// 如果查询不到，返回空
	if err != nil {
		return nil, err
	}
	permissionTree := build_permission_tree.BuildPermissionTree(permissions)
	// 如果查询到，返回权限列表
	return permissionTree, nil
}
