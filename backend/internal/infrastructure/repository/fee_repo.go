package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"time"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
)

type FeeRepository struct {
	DB *gorm.DB
}

func NewFeeRepository(db *gorm.DB) *FeeRepository {
	return &FeeRepository{DB: db}
}

// GetWaitingFeeBillsByUserID 根据用户ID获取待缴费账单
func (r *FeeRepository) GetWaitingFeeBillsByUserID(userID int) ([]domain.FeeBill, error) {
	var bills []domain.FeeBill
	err := r.DB.Where("user_id = ? AND paid = false", userID).Order("due_date ASC").Find(&bills).Error
	return bills, err
}

// FetchActiveFeePayingMembers 检索所有需要缴纳会费的活跃会员。
func (r *FeeRepository) FetchActiveFeePayingMembers() ([]domain.User, error) {
	var users []domain.User
	err := r.DB.Where("user_type_id = ? AND is_fee_active = ?", 2, true).Find(&users).Error
	fmt.Println(users)
	return users, err
}

// InsertFeeBill 将新的会费账单插入数据库。
func (r *FeeRepository) InsertFeeBill(bill domain.FeeBill) error {
	return r.DB.Create(&bill).Error
}

func (r *FeeRepository) CreateNewBill(bill domain.FeeBill) error {
	return r.DB.Create(&bill).Error
}

func (r *FeeRepository) CheckBillExists(userID uint, billingPeriod string) (bool, error) {
	var count int64
	err := r.DB.Model(&domain.FeeBill{}).Where("user_id = ? AND billing_period = ?", userID, billingPeriod).Count(&count).Error
	return count > 0, err
}

// GetActiveFeeMembers 返回所有激活了会费的用户详细信息
func (r *FeeRepository) GetActiveFeeMembers() ([]domain.MemberFeeInfo, error) {
	var memberFeeInfo []domain.MemberFeeInfo
	err := r.DB.Where("is_fee_active = ?", true).Find(&memberFeeInfo).Error
	return memberFeeInfo, err
}

// CreateFeeBill 为指定用户创建一个新的会费账单
func (r *FeeRepository) CreateFeeBill(bill domain.FeeBill) error {
	return r.DB.Create(&bill).Error
}

// GetFeeHistoryByUserID 根据用户ID获取会费历史记录
func (r *FeeRepository) GetFeeHistoryByUserID(userID uint, pageSize, pageNum int) ([]domain.FeeBill, uint, error) {
	var bills []domain.FeeBill
	var total int64
	query := r.DB.Where("user_id = ? AND paid = ?", userID, true)
	err := query.Order("created_at DESC").Limit(pageSize).Offset((pageNum - 1) * pageSize).Find(&bills).Error
	query.Model(&domain.FeeBill{}).Count(&total) // 确保这里使用相同的查询条件
	return bills, uint(total), err
}

func (r *FeeRepository) CheckFeePaid(billID uint) (bool, error) {
	var bill domain.FeeBill
	result := r.DB.Select("paid").Where("bill_id = ?", billID).First(&bill)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return false, nil // 账单未找到也返回false，但无错误
		}
		return false, result.Error
	}
	return bill.Paid, nil
}

// CheckFeePaidNew 检查账单是否已支付
func (r *FeeRepository) CheckFeePaidNew(userID, billID uint) (bool, error) {
	var bill domain.FeeBill
	result := r.DB.Select("user_id, paid").Where("bill_id = ?", billID).First(&bill)
	// 如果user_id不匹配，返回false
	if bill.UserID != userID {
		return false, errors.New("账单不存在")
	}
	if result.Error != nil {
		return false, result.Error
	}
	return bill.Paid, nil
}

// MarkFeeAsPaid 标记会费账单为已支付
func (r *FeeRepository) MarkFeeAsPaid(userID, billID uint) error {
	result := r.DB.Model(&domain.FeeBill{}).
		Where("bill_id = ?", billID).
		Where("user_id = ?", userID).
		Update("paid", true)
	return result.Error
}

func (r *FeeRepository) GetRegisteredUsersWithFeeStandard(pageSize, pageNum uint) ([]dto.UserWithFee, uint, error) {
	var usersWithFees []dto.UserWithFee
	err := r.DB.
		Table("tb_user").
		Select("tb_user.user_id, tb_user.username, tb_user.email, tb_user.phone_number, tb_user.registration_date, tb_fee_standard_new.standard_amount AS fee_amount, tb_fee_standard_new.standard_name AS fee_standard_name, tb_fee_standard_new.standard_id as fee_standard_id").
		Joins("JOIN tb_fee_standard_new ON tb_user.fee_standard = tb_fee_standard_new.standard_id").
		Where("tb_user.is_active = ?", true).
		Offset(int(pageNum)).
		Limit(int(pageSize)).
		Find(&usersWithFees).Error
	if err != nil {
		return nil, 0, err
	}

	// 计算符合条件的总记录数
	var total int64
	err = r.DB.
		Table("tb_user").
		Joins("JOIN tb_fee_standard_new ON tb_user.fee_standard = tb_fee_standard_new.standard_id").
		Where("tb_user.is_active = ?", true).
		Count(&total).Error

	return usersWithFees, uint(total), nil
}

// GetNonRegisteredUsers 获取未注册的用户
func (r *FeeRepository) GetNonRegisteredUsers(pageSize, pageNum uint) ([]domain.User, uint, error) {
	var users []domain.User
	var total int64
	err := r.DB.
		Table("tb_user").
		Where("is_active = ? AND fee_standard = ? AND user_type_id = ?", true, -1, 2).
		Offset(int(pageNum) - 1).
		Limit(int(pageSize)).
		Find(&users).Error
	if err != nil {
		return nil, 0, err
	}

	err = r.DB.
		Table("tb_user").
		Where("is_active = ? AND fee_standard = ? AND user_type_id = ?", true, -1, 2).
		Count(&total).Error

	return users, uint(total), nil
}

// GetFeeStandard 获取所有会费标准
func (r *FeeRepository) GetFeeStandard() ([]domain.FeeStandardNew, error) {
	var feeStandards []domain.FeeStandardNew
	err := r.DB.Table("tb_fee_standard_new").Find(&feeStandards).Error
	return feeStandards, err
}

// ModifyFeeStandard 修改会费标准
func (r *FeeRepository) ModifyFeeStandard(feeStandardID uint, amount float64, name string) error {
	result := r.DB.Model(&domain.FeeStandardNew{}).
		Where("standard_id = ?", feeStandardID).
		Update("standard_amount", amount).
		Update("standard_name", name)
	return result.Error
}

// AddFeeStandard 添加会费标准
func (r *FeeRepository) AddFeeStandard(amount string, name string) error {
	return r.DB.Create(&domain.FeeStandardNew{StandardAmount: amount, StandardName: name}).Error
}

// CheckFeeStandardExists 检查会费标准是否存在
func (r *FeeRepository) CheckFeeStandardExists(standardID uint) (bool, error) {
	var count int64
	err := r.DB.Model(&domain.FeeStandardNew{}).Where("standard_id = ?", standardID).Count(&count).Error
	fmt.Println(count > 0)
	return count > 0, err
}

// ChangeFeeStandard 修改用户的会费标准
func (r *FeeRepository) ChangeFeeStandard(userID uint, newStandardID uint) error {
	result := r.DB.Model(&domain.User{}).
		Where("user_id = ?", userID).
		Update("fee_standard", newStandardID)
	return result.Error
}

// RemoveMemberFeeStandard 移除用户的会费标准
func (r *FeeRepository) RemoveMemberFeeStandard(userID uint) error {
	result := r.DB.Model(&domain.User{}).
		Where("user_id = ?", userID).
		Update("fee_standard", -1)
	return result.Error
}

// CheckUserExists 检查用户是否存在
func (r *FeeRepository) CheckUserExists(userID uint) (bool, error) {
	var count int64
	err := r.DB.Model(&domain.User{}).Where("user_id = ?", userID).Count(&count).Error
	return count > 0, err
}

// CheckUserHasFeeStandard 检查用户是否已经有会费标准
func (r *FeeRepository) CheckUserHasFeeStandard(userID uint) (bool, error) {
	var count int64
	err := r.DB.Model(&domain.User{}).Where("user_id = ? AND fee_standard != ?", userID, -1).Count(&count).Error
	return count > 0, err
}

// CheckFeeStandard 检查用户的会费标准ID
func (r *FeeRepository) CheckFeeStandard(userID uint) (uint, error) {
	var feeStandardID uint
	err := r.DB.Model(&domain.User{}).Select("fee_standard").Where("user_id = ?", userID).First(&feeStandardID).Error
	return feeStandardID, err
}

// GetFeeStandardById 根据ID获取会费标准
func (r *FeeRepository) GetFeeStandardById(standardID uint) (domain.FeeStandardNew, error) {
	var feeStandard domain.FeeStandardNew
	err := r.DB.Where("standard_id = ?", standardID).First(&feeStandard).Error
	return feeStandard, err
}

// GetBills 分页获取账单
func (r *FeeRepository) GetBills(pageSize uint, pageNum uint) ([]domain.FeeBill, uint, error) {
	var bills []domain.FeeBill
	var total int64
	err := r.DB.
		Order("created_at DESC").
		Limit(int(pageSize)).
		Offset(int(pageNum-1) * int(pageSize)).
		Find(&bills).Error
	if err != nil {
		return nil, 0, err
	}
	err = r.DB.Model(&domain.FeeBill{}).Count(&total).Error
	return bills, uint(total), err
}

// GetUserNameByIds 根据用户ID获取用户名
func (r *FeeRepository) GetUserNameByIds(userIdMap map[int]uint) ([]domain.User, error) {
	var users []domain.User
	// Convert map values to slice
	var userIds []uint
	for _, id := range userIdMap {
		userIds = append(userIds, id)
	}
	err := r.DB.Where("user_id IN ?", userIds).Find(&users).Error
	return users, err
}

// GetAllRegisteredFeeStandardUser 获取所有已注册的会费标准用户
func (r *FeeRepository) GetAllRegisteredFeeStandardUser() ([]domain.User, error) {
	var users []domain.User
	err := r.DB.Where("fee_standard != ?", -1).
		Where("is_active", true).
		Find(&users).Error
	return users, err
}

// GetFeeStandardByIds 根据ID列表获取会费标准
func (r *FeeRepository) GetFeeStandardByIds(ids []int) ([]domain.FeeStandardNew, error) {
	var feeStandards []domain.FeeStandardNew
	err := r.DB.Where("standard_id IN ?", ids).Find(&feeStandards).Error
	return feeStandards, err
}

func (r *FeeRepository) CheckBillExistsNew(userIDs []uint, billingPeriod string) ([]uint, error) {
	var userIds []uint
	err := r.DB.Model(&domain.FeeBill{}).Where("user_id in ? AND billing_period = ?", userIDs, billingPeriod).Pluck("user_id", &userIds).Error
	return userIds, err
}

// CreateFeeBillNew 创建新的会费账单 s.Repo.CreateFeeBillNew(memberStandardMap, standard, billingPeriod, dueDate)
func (r *FeeRepository) CreateFeeBillNew(memberStandardMap map[uint]int, standard []domain.FeeStandardNew, billingPeriod string, dueDate time.Time) error {
	var bills []domain.FeeBill
	for userID, feeStandard := range memberStandardMap {
		for _, s := range standard {
			if s.StandardId == uint(feeStandard) {
				bill := domain.FeeBill{
					UserID:        userID,
					BillingPeriod: billingPeriod,
					DueDate:       dueDate,
					Amount:        s.StandardAmount,
				}
				bills = append(bills, bill)
				break
			}
		}
	}
	return r.DB.Create(&bills).Error
}
