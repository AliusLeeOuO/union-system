package repository

import (
	"gorm.io/gorm"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/utils/password_crypt"
)

// UserRepository DDD设计模式 实验性代码
type UserRepository struct {
	DB *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (r *UserRepository) GetUsers(page uint, pageSize uint, username string, userId uint, userRole uint) ([]dto.UserWithPermissionInfo, uint, error) {
	var userWithPermissions []dto.UserWithPermissionInfo
	offset := (page - 1) * pageSize
	query := r.DB.Table("tb_user").
		Select("tb_user.user_id, tb_user.username, tb_user.registration_date as create_time, tb_user.email, tb_user.phone_number, tb_user.user_role as account_type, tb_user_type.type_name, tb_user.user_type_id as role, tb_user_type.description as role_name, tb_user.is_active").
		Joins("JOIN tb_user_type ON tb_user.user_type_id = tb_user_type.type_id").
		Offset(int(offset)).
		Limit(int(pageSize))
	if username != "" {
		query = query.Where("tb_user.username LIKE ?", "%"+username+"%")
	}
	if userId != 0 {
		query = query.Where("tb_user.user_id = ?", userId)
	}
	if userRole != 0 {
		query = query.Where("tb_user.user_type_id = ?", userRole)
	}
	if err := query.Find(&userWithPermissions).Error; err != nil {
		return nil, 0, err
	}
	// 计算符合条件的总记录数 带上筛选条件
	var total int64
	err := r.DB.Table("tb_user").
		Joins("JOIN tb_user_type ON tb_user.user_type_id = tb_user_type.type_id")

	if username != "" {
		err = err.Where("tb_user.username LIKE ?", "%"+username+"%")
	}
	if userId != 0 {
		err = err.Where("tb_user.user_id = ?", userId)
	}
	if userRole != 0 {
		err = err.Where("tb_user.user_type_id = ?", userRole)
	}
	countError := err.Count(&total).Error
	if countError != nil {
		return nil, 0, countError
	}
	return userWithPermissions, uint(total), nil
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

func (r *UserRepository) CreateUser(username string, password string, email string, role uint, phone string, accountType string) (uint, error) {
	user := domain.User{
		Username:    username,
		Password:    password,
		Email:       email,
		UserTypeID:  role,
		PhoneNumber: phone,
		UserRole:    accountType,
	}

	result := r.DB.Omit("registration_date", "is_active", "fee_standard").Create(&user)
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

// GetRolePermissions 获取角色的权限关联ID
func (r *UserRepository) GetRolePermissions(roleID uint) ([]uint, error) {
	var permissions []uint
	result := r.DB.Model(&domain.RolePermission{}).Where("role_id = ?", roleID).Pluck("permission_id", &permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// GetPermissionsByIDs 根据权限ID获取权限
func (r *UserRepository) GetPermissionsByIDs(permissionIDs []uint) ([]domain.Permission, error) {
	var permissions []domain.Permission
	result := r.DB.Where("permission_id IN ?", permissionIDs).Order("list_order ASC").Find(&permissions)
	if result.Error != nil {
		return nil, result.Error
	}
	return permissions, nil
}

// GetRoleGroupList 获取角色组列表
func (r *UserRepository) GetRoleGroupList() ([]domain.UserType, error) {
	var roleGroups []domain.UserType
	result := r.DB.Find(&roleGroups)
	if result.Error != nil {
		return nil, result.Error
	}
	return roleGroups, nil
}
