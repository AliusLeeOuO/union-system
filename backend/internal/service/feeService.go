package service

import (
	"errors"
	"fmt"
	"time"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
)

type FeeService struct {
	Repo *repository.FeeRepository
}

func NewFeeService(repo *repository.FeeRepository) *FeeService {
	return &FeeService{Repo: repo}
}

// GetFeeStandardByCategory 根据会员类别获取会费标准
func (s *FeeService) GetFeeStandardByCategory(categoryID uint) (model.FeeStandard, error) {
	return s.Repo.GetFeeStandardByCategory(categoryID)
}

// GetWaitingFeeBillsByUserID 返回用户待缴费账单
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

			bill := model.FeeBill{
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

// GetFeeHistory 获取用户的会费历史记录
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

// PayFee 处理会费支付
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
