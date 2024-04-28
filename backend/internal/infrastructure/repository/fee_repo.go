package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
)

type FeeRepository struct {
	DB *gorm.DB
}

func NewFeeRepository(db *gorm.DB) *FeeRepository {
	return &FeeRepository{DB: db}
}

// GetFeeStandardByCategory 根据会员类别获取会费标准
func (r *FeeRepository) GetFeeStandardByCategory(categoryID uint) (domain.FeeStandard, error) {
	var standards domain.FeeStandard
	err := r.DB.Where("category_id = ?", categoryID).First(&standards).Error
	return standards, err
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
	fmt.Println("---------------------------------")
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

// CheckFeePaid 检查用户指定账单是否已支付
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

// MarkFeeAsPaid 标记会费账单为已支付
func (r *FeeRepository) MarkFeeAsPaid(billID uint) error {
	result := r.DB.Model(&domain.FeeBill{}).Where("bill_id = ?", billID).Update("paid", true)
	return result.Error
}

func (r *FeeRepository) GetRegisteredUsersWithFeeStandard(pageSize, pageNum uint) ([]dto.UserWithFee, uint, error) {
	var usersWithFees []dto.UserWithFee
	err := r.DB.
		Table("tb_user").
		Select("tb_user.user_id, tb_user.username, tb_user.email, tb_user.phone_number, tb_user.registration_date, tb_fee_standard_new.standard_amount AS fee_amount").
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

//func (r *FeeRepository) GetRegisteredUsersWithFeeStandard(pageSize, pageNum uint) (dto.UserWithFee, error) {
//	var usersWithFees []dto.UserWithFee
//	var total int64
//
//	// 计算符合条件的总记录数
//	err := r.DB.
//		Table("tb_user").
//		Joins("JOIN tb_fee_standard_new ON tb_user.fee_standard = tb_fee_standard_new.standard_id").
//		Where("tb_user.is_active = ?", true).
//		Count(&total).Error
//	if err != nil {
//		return dto.UserWithFee{}, err
//	}
//
//	// 分页查询数据
//	err = r.DB.
//		Table("tb_user").
//		Select("tb_user.user_id, tb_user.username, tb_user.email, tb_user.phone_number, tb_user.registration_date, tb_fee_standard_new.standard_amount AS fee_amount").
//		Joins("JOIN tb_fee_standard_new ON tb_user.fee_standard = tb_fee_standard_new.standard_id").
//		Where("tb_user.is_active = ?", true).
//		Offset(int(pageNum - 1) * int(pageSize)).
//		Limit(int(pageSize)).
//		Find(&usersWithFees).Error
//	if err != nil {
//		return dto.UserWithFee{}, err
//	}
//
//	return dto.PaginatedUsersWithFees{Users: usersWithFees, Total: total}, nil
//}
