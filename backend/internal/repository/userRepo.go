package repository

import (
	"gorm.io/gorm"
	"time"
	"union-system/global"
	"union-system/internal/model/domain"
	"union-system/utils/password_crypt"
)

// UserRepository DDD设计模式 实验性代码
type UserRepository struct {
	DB *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (r *UserRepository) GetUsers(page int, pageSize int, username string, userId uint, userRole uint) ([]domain.User, error) {
	var users []domain.User
	offset := (page - 1) * pageSize

	query := r.DB.Model(&domain.User{}).Omit("Password").Order("user_id ASC").Offset(offset).Limit(pageSize)
	if username != "" {
		query = query.Where("username LIKE ?", "%"+username+"%")
	}
	if userId != 0 {
		query = query.Where("user_id = ?", userId)
	}
	if userRole != 0 {
		query = query.Where("user_type_id = ?", userRole)
	}

	if err := query.Find(&users).Error; err != nil {
		return nil, err
	}
	return users, nil
}

func (r *UserRepository) CountAdminUsers(username string, userId uint, userRole uint) (int64, error) {
	var count int64
	query := r.DB.Model(&domain.User{})
	if username != "" {
		query = query.Where("username LIKE ?", "%"+username+"%")
	}
	if userId != 0 {
		query = query.Where("user_id = ?", userId)
	}
	if userRole != 0 {
		query = query.Where("user_type_id = ?", userRole)
	}

	if err := query.Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}

func (r *UserRepository) GetUserByUsername(username string) (*domain.User, error) {
	var user domain.User
	result := r.DB.Where("username = ?", username).First(&user)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}

func (r *UserRepository) GetUserByID(userID uint) (*domain.User, error) {
	var user domain.User
	result := r.DB.First(&user, userID)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}

func (r *UserRepository) CheckUserPassword(userID uint, password string) bool {
	var user domain.User
	result := r.DB.First(&user, userID)
	if result.Error != nil {
		return false
	}

	return password_crypt.PasswordVerify(password, user.Password)
}

func (r *UserRepository) ChangePasswordByID(userID uint, newPassword string) error {
	var user domain.User
	result := r.DB.First(&user, userID)
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

func (r *UserRepository) CreateUser(username string, password string, email string, role uint, phone string) (uint, error) {
	user := domain.User{
		Username:    username,
		Password:    password,
		Email:       email,
		UserTypeID:  role,
		PhoneNumber: phone,
	}

	result := r.DB.Omit("registration_date", "is_active").Create(&user)
	if result.Error != nil {
		return 0, result.Error
	}
	return user.UserID, nil
}

// CheckPassword 检查用户的密码是否正确
func (r *UserRepository) CheckPassword(userID uint, password string) (bool, error) {
	var user domain.User
	if err := r.DB.First(&user, userID).Error; err != nil {
		return false, err
	}

	// 验证密码，bcrypt.CompareHashAndPassword
	if password_crypt.PasswordVerify(password, user.Password) {
		return true, nil
	}

	return false, nil
}

// VerifyInvitationCode 验证邀请码验证
func (r *UserRepository) VerifyInvitationCode(code string) (*domain.InvitationCodes, error) {
	var invitationCode domain.InvitationCodes
	now := time.Now()

	err := r.DB.Where("code = ? AND expires_at > ? AND is_used = false", code, now).First(&invitationCode).Error
	if err != nil {
		return nil, err
	}

	return &invitationCode, nil
}

// MarkInvitationCodeAsUsed 标记邀请码为已使用
func (r *UserRepository) MarkInvitationCodeAsUsed(codeID uint, userID uint) error {
	return r.DB.Model(&domain.InvitationCodes{}).Where("code_id = ?", codeID).Updates(map[string]interface{}{"is_used": true, "used_by_user_id": userID}).Error
}

func (r *UserRepository) GetInvitationCodes(pageNum, pageSize uint) ([]domain.InvitationCodes, uint, error) {
	var codes []domain.InvitationCodes
	var total int64

	offset := (pageNum - 1) * pageSize

	// 先计算总数
	result := r.DB.Model(&domain.InvitationCodes{}).Count(&total)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 分页查询
	result = r.DB.Offset(int(offset)).Limit(int(pageSize)).Find(&codes)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	return codes, uint(total), nil
}

func (r *UserRepository) CreateInvitationCode(invitationCode *domain.InvitationCodes) error {
	return r.DB.Create(invitationCode).Error
}
