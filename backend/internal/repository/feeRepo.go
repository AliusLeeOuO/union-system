package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"union-system/internal/model"
)

type FeeRepository struct {
	DB *gorm.DB
}

func NewFeeRepository(db *gorm.DB) *FeeRepository {
	return &FeeRepository{DB: db}
}

// GetFeeStandardByCategory 根据会员类别获取会费标准
func (r *FeeRepository) GetFeeStandardByCategory(categoryID uint) (model.FeeStandard, error) {
	var standards model.FeeStandard
	err := r.DB.Where("category_id = ?", categoryID).First(&standards).Error
	return standards, err
}

// GetWaitingFeeBillsByUserID 根据用户ID获取待缴费账单
func (r *FeeRepository) GetWaitingFeeBillsByUserID(userID int) ([]model.FeeBill, error) {
	var bills []model.FeeBill
	err := r.DB.Where("user_id = ? AND paid = false", userID).Order("due_date ASC").Find(&bills).Error
	return bills, err
}

// FetchActiveFeePayingMembers 检索所有需要缴纳会费的活跃会员。
func (r *FeeRepository) FetchActiveFeePayingMembers() ([]model.User, error) {
	var users []model.User
	err := r.DB.Where("user_type_id = ? AND is_fee_active = ?", 2, true).Find(&users).Error
	fmt.Println("---------------------------------")
	fmt.Println(users)
	return users, err
}

// InsertFeeBill 将新的会费账单插入数据库。
func (r *FeeRepository) InsertFeeBill(bill model.FeeBill) error {
	return r.DB.Create(&bill).Error
}

func (r *FeeRepository) CreateNewBill(bill model.FeeBill) error {
	return r.DB.Create(&bill).Error
}

func (r *FeeRepository) CheckBillExists(userID uint, billingPeriod string) (bool, error) {
	var count int64
	err := r.DB.Model(&model.FeeBill{}).Where("user_id = ? AND billing_period = ?", userID, billingPeriod).Count(&count).Error
	return count > 0, err
}

// GetActiveFeeMembers 返回所有激活了会费的用户详细信息
func (r *FeeRepository) GetActiveFeeMembers() ([]model.MemberFeeInfo, error) {
	var memberFeeInfo []model.MemberFeeInfo
	err := r.DB.Where("is_fee_active = ?", true).Find(&memberFeeInfo).Error
	return memberFeeInfo, err
}

// CreateFeeBill 为指定用户创建一个新的会费账单
func (r *FeeRepository) CreateFeeBill(bill model.FeeBill) error {
	return r.DB.Create(&bill).Error
}

// GetFeeHistoryByUserID 根据用户ID获取会费历史记录
func (r *FeeRepository) GetFeeHistoryByUserID(userID uint, pageSize, pageNum int) ([]model.FeeBill, uint, error) {
	var bills []model.FeeBill
	var total int64
	query := r.DB.Where("user_id = ? AND paid = ?", userID, true)
	err := query.Order("created_at DESC").Limit(pageSize).Offset((pageNum - 1) * pageSize).Find(&bills).Error
	query.Model(&model.FeeBill{}).Count(&total) // 确保这里使用相同的查询条件
	return bills, uint(total), err
}

// CheckFeePaid 检查用户指定账单是否已支付
func (r *FeeRepository) CheckFeePaid(billID uint) (bool, error) {
	var bill model.FeeBill
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
	result := r.DB.Model(&model.FeeBill{}).Where("bill_id = ?", billID).Update("paid", true)
	return result.Error
}
