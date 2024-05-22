package dto

import "time"

// FeeBillResponse 用于返回给用户的等待缴费账单信息
type FeeBillResponse struct {
	BillID        uint   `json:"bill_id"`                  // 账单ID
	UserID        uint   `json:"user_id"`                  // 用户ID
	UserName      string `json:"user_name"`                // 用户名
	Amount        string `json:"amount"`                   // 应缴费用金额
	DueDate       string `json:"due_date"`                 // 缴费截止日期
	FeePeriod     string `json:"fee_period"`               // 缴费周期，例如“2024年第一季度”
	FeeCategory   string `json:"fee_category"`             // 费用类别，例如“普通会员会费”
	PaymentStatus bool   `json:"payment_status"`           // 缴费状态，例如“未支付”
	PaymentMethod string `json:"payment_method,omitempty"` // 缴费方式，例如“在线支付”，可选字段，如果还未支付则可能为空
	CreatedAt     string `json:"created_at"`               // 账单生成时间
}

// FeeHistoryResponse 用于返回给用户的会费历史记录
type FeeHistoryResponse struct {
	PageResponse
	History []FeeBillResponse `json:"history"`
}

// WaitingFeeResponse 用于返回给用户的等待缴费账单信息
type WaitingFeeResponse struct {
	Bills []FeeBillResponse `json:"bills"`
}

type UserWithFee struct {
	UserID           uint      `json:"user_id"`
	Username         string    `json:"username"`
	Email            string    `json:"email"`
	PhoneNumber      string    `json:"phone_number"`
	RegistrationDate time.Time `json:"registration_date"`
	FeeAmount        string    `json:"fee_amount"` // 从 FeeStandardNew 表获取
	FeeStandardName  string    `json:"fee_standard_name"`
	FeeStandardId    uint      `json:"fee_standard_id"`
}

type UserWithFeeResponse struct {
	PageResponse
	Users []UserWithFee `json:"users"`
}

type UserNonFee struct {
	UserID      uint   `json:"user_id"`
	Username    string `json:"username"`
	Email       string `json:"email"`
	PhoneNumber string `json:"phone_number"`
	RegisterAt  string `json:"register_at"`
}

type UserNonFeeResponse struct {
	PageResponse
	Users []UserNonFee `json:"users"`
}

type FeeStandard struct {
	StandardID   uint   `json:"standard_id"`
	StandardName string `json:"standard_name"`
	Amount       string `json:"amount"`
}
