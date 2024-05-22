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
		})
	}
	return responses, nil
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
			UserID:        bill.UserID,
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

func (s *FeeService) PayFee(userID, billID uint) error {
	// 首先检查账单是否已支付
	paid, err := s.Repo.CheckFeePaidNew(userID, billID)
	if err != nil {
		return err
	}
	if paid {
		return errors.New("账单已支付")
	}
	return s.Repo.MarkFeeAsPaid(userID, billID)
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

// CheckFeeStatus 检查会费状态
func (s *FeeService) CheckFeeStatus(userID uint) (bool, error) {
	return s.Repo.CheckUserHasFeeStandard(userID)
}

func (s *FeeService) CheckFeeStandard(userId uint) (domain.FeeStandardNew, error) {
	standardId, err := s.Repo.CheckFeeStandard(userId)
	if err != nil {
		return domain.FeeStandardNew{}, err
	}
	return s.Repo.GetFeeStandardById(standardId)
}

// GetBills 分页获取账单
func (s *FeeService) GetBills(pageSize uint, pageNum uint) ([]dto.FeeBillResponse, uint, error) {
	offset := (pageNum - 1) * pageSize
	bills, total, err := s.Repo.GetBills(pageSize, offset)
	if err != nil {
		return nil, 0, err
	}
	// ��用map存储bills[i]: userId 的键值对
	userIdMap := make(map[int]uint)
	for index, bill := range bills {
		userIdMap[index] = bill.UserID
	}
	// 获取用户信息
	users, err := s.Repo.GetUserNameByIds(userIdMap)

	// Create a map where the keys are the user IDs and the values are the user names
	userNameMap := make(map[uint]string)
	for _, user := range users {
		userNameMap[user.UserID] = user.Username
	}

	var responses []dto.FeeBillResponse
	// 将用户信息与账单信息合并
	for _, bill := range bills {
		responses = append(responses, dto.FeeBillResponse{
			BillID:        bill.BillID,
			UserID:        bill.UserID,
			Amount:        bill.Amount,
			DueDate:       bill.DueDate.Format(time.RFC3339),
			CreatedAt:     bill.CreatedAt.Format(time.RFC3339),
			PaymentStatus: bill.Paid,
			FeePeriod:     bill.BillingPeriod,
			UserName:      userNameMap[bill.UserID], // Get the user name from the map
		})
	}

	return responses, total, nil
}

// GenerateMonthlyFeeBillsNew 生成月度会费账单
func (s *FeeService) GenerateMonthlyFeeBillsNew(billingPeriod string) error {
	// 获取所有激活了会费的会员
	memberDetails, err := s.Repo.GetAllRegisteredFeeStandardUser()
	if err != nil {
		return fmt.Errorf("获取激活会费的会员失败: %w", err)
	}

	// 获取当前日期，用于确定账单创建和到期时间
	now := time.Now()
	dueDate := now.AddDate(0, 1, -now.Day()) // 下个月的最后一天
	// 查询会员类别的会费标准
	// 收集所有会费标准和会员ID
	feeStandardMap := make(map[int]bool)
	var memberIds []uint
	for _, member := range memberDetails {
		memberIds = append(memberIds, member.UserID)
		_, ok := feeStandardMap[member.FeeStandard]
		if !ok {
			feeStandardMap[member.FeeStandard] = true
		}
	}
	// 从map中读取出ID数组
	var feeStandards []int
	for i, _ := range feeStandardMap {
		feeStandards = append(feeStandards, i)
	}
	// 传入Repo中进行查询会费标准
	standard, err := s.Repo.GetFeeStandardByIds(feeStandards)
	if err != nil {
		return err
	}
	// 检查是否已经为当前账期生成了账单，先查询所有账单
	existBillMemberIds, err := s.Repo.CheckBillExistsNew(memberIds, billingPeriod)
	if err != nil {
		return err
	}
	// 将已存在的账单ID从memberIds中删除
	for _, id := range existBillMemberIds {
		for i, memberId := range memberIds {
			if memberId == id {
				memberIds = append(memberIds[:i], memberIds[i+1:]...)
				break
			}
		}
	}
	// 为剩余的用户创建账单创建一个map，key为用户ID，value为会费标准，然后传入repo
	memberStandardMap := make(map[uint]int)

	// 创建一个map，key为用户ID，value为会费标准
	memberDetailsMap := make(map[uint]int)
	for _, member := range memberDetails {
		memberDetailsMap[member.UserID] = member.FeeStandard
	}

	// 仅限于已注册会费标准的用户
	for _, memberId := range memberIds {
		memberStandardMap[memberId] = memberDetailsMap[memberId]
	}

	// 如果没有任何用户需要创建账单，直接返回
	if len(memberStandardMap) == 0 {
		return nil
	}

	// 将整个map传入repo
	if err = s.Repo.CreateFeeBillNew(memberStandardMap, standard, billingPeriod, dueDate); err != nil {
		return err
	}

	return nil
}
