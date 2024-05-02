package service

import (
	"errors"
	"fmt"
	"time"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
)

type FeeService struct {
	Repo *repository.FeeRepository
}

func NewFeeService(repo *repository.FeeRepository) *FeeService {
	return &FeeService{Repo: repo}
}

// Deprecated: 请使用新方法
func (s *FeeService) GetFeeStandardByCategory(categoryID uint) (domain.FeeStandard, error) {
	return s.Repo.GetFeeStandardByCategory(categoryID)
}

// Deprecated: 请使用新方法
func (s *FeeService) GetWaitingFeeBillsByUserID(userID int) ([]dto.FeeBillResponse, error) {
	bills, err := s.Repo.GetWaitingFeeBillsByUserID(userID)
	if err != nil {
		return nil, err
	}

	var responses []dto.FeeBillResponse
	for _, bill := range bills {
		responses = append(responses, dto.FeeBillResponse{
			BillID:        bill.BillID,
			Amount:        bill.Amount,
			DueDate:       bill.DueDate.Format(time.RFC3339),
			CreatedAt:     bill.CreatedAt.Format(time.RFC3339),
			PaymentStatus: bill.Paid,
			FeePeriod:     bill.BillingPeriod,
			FeeCategory:   "会费",
		})
	}
	return responses, nil
}

// Deprecated: 请使用新方法
func (s *FeeService) GenerateMonthlyFeeBills(billingPeriod string) error {
	// 获取所有激活了会费的会员
	memberDetails, err := s.Repo.GetActiveFeeMembers()
	if err != nil {
		return fmt.Errorf("获取激活会费的会员失败: %w", err)
	}

	// 获取当前日期，用于确定账单创建和到期时间
	now := time.Now()
	dueDate := now.AddDate(0, 1, -now.Day()) // 下个月的最后一天
	// 查询会员类别的会费标准
	feeStandard, _ := s.GetFeeStandardByCategory(1)
	for _, detail := range memberDetails {
		// 检查是否已经为当前账期生成了账单
		exists, err := s.Repo.CheckBillExists(detail.UserID, billingPeriod)
		if err != nil {
			return fmt.Errorf("检查账单存在失败: %w", err)
		}

		// 如果账单不存在，为用户创建新的账单
		if !exists {

			bill := domain.FeeBill{
				UserID:        int(detail.UserID),
				Amount:        feeStandard.Amount,
				CreatedAt:     now,
				DueDate:       dueDate,
				Paid:          false,
				BillingPeriod: billingPeriod,
			}

			if err := s.Repo.CreateFeeBill(bill); err != nil {
				return fmt.Errorf("创建会费账单失败: %w", err)
			}
		}
	}

	return nil
}

// Deprecated: 请使用新方法
func (s *FeeService) GetFeeHistory(userID uint, pageSize, pageNum uint) (dto.FeeHistoryResponse, error) {
	bills, total, err := s.Repo.GetFeeHistoryByUserID(userID, int(pageSize), int(pageNum))
	if err != nil {
		return dto.FeeHistoryResponse{}, err
	}

	var responses dto.FeeHistoryResponse
	for _, bill := range bills {
		responses.History = append(responses.History, dto.FeeBillResponse{
			BillID:        bill.BillID,
			UserID:        uint(bill.UserID),
			Amount:        bill.Amount,
			DueDate:       bill.DueDate.Format(time.RFC3339),
			CreatedAt:     bill.CreatedAt.Format(time.RFC3339),
			PaymentStatus: bill.Paid,
			FeePeriod:     bill.BillingPeriod,
			FeeCategory:   "会费",
		})
	}
	responses.Total = total
	responses.PageSize = pageSize
	responses.PageNum = pageNum

	return responses, nil
}

// Deprecated: 请使用新方法
func (s *FeeService) PayFee(billID uint) error {
	// 首先检查账单是否已支付
	paid, err := s.Repo.CheckFeePaid(billID)
	if err != nil {
		return err
	}
	if paid {
		return errors.New("会费已支付，无需重复支付")
	}
	// 标记账单为已支付
	return s.Repo.MarkFeeAsPaid(billID)
}

func (s *FeeService) GetRegisteredFeeList(pageSize, pageNum uint) ([]dto.UserWithFee, uint, error) {
	offset := (pageNum - 1) * pageSize
	usersWithFees, total, err := s.Repo.GetRegisteredUsersWithFeeStandard(pageSize, offset)
	if err != nil {
		return nil, 0, err
	}
	return usersWithFees, total, nil
}

// GetNonRegisteredUsers 获取未注册会费的用户
func (s *FeeService) GetNonRegisteredUsers(pageSize, pageNum uint) ([]domain.User, uint, error) {
	users, total, err := s.Repo.GetNonRegisteredUsers(pageSize, pageNum)
	if err != nil {
		return nil, 0, err
	}
	return users, total, nil
}

// GetFeeStandardList 获取会费标准列表
func (s *FeeService) GetFeeStandardList() ([]dto.FeeStandard, error) {
	feeStandardList, err := s.Repo.GetFeeStandard()
	if err != nil {
		return nil, err
	}
	var res []dto.FeeStandard
	for _, feeStandard := range feeStandardList {
		res = append(res, dto.FeeStandard{
			StandardID:   feeStandard.StandardId,
			StandardName: feeStandard.StandardName,
			Amount:       feeStandard.StandardAmount,
		})
	}
	return res, nil
}

// ModifyFeeStandard 修改会费标准
func (s *FeeService) ModifyFeeStandard(feeStandardID uint, amount float64, name string) error {
	return s.Repo.ModifyFeeStandard(feeStandardID, amount, name)
}

// AddFeeStandard 添加会费标准
func (s *FeeService) AddFeeStandard(amount float64, name string) error {
	// 金额转为字符串
	amountStr := fmt.Sprintf("%.2f", amount)
	return s.Repo.AddFeeStandard(amountStr, name)
}

// ChangeFeeStandard 修改用户会费标准
func (s *FeeService) ChangeFeeStandard(userID, newStandardID uint) error {
	// 检查新的会费标准是否存在
	exists, err := s.Repo.CheckFeeStandardExists(newStandardID)
	if !exists {
		return errors.New("会费标准不存在")
	}
	if err != nil {
		return err
	}
	return s.Repo.ChangeFeeStandard(userID, newStandardID)
}

// RemoveMemberFeeStandard 移除用户会费标准
func (s *FeeService) RemoveMemberFeeStandard(userID uint) error {
	// 检查用户是否存在
	exists, err := s.Repo.CheckUserExists(userID)
	if !exists {
		return errors.New("用户不存在")
	}
	if err != nil {
		return err
	}
	return s.Repo.RemoveMemberFeeStandard(userID)
}
