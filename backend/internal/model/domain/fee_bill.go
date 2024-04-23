package domain

import "time"

// FeeBill tb_fee_bill
type FeeBill struct {
	BillID        uint      `gorm:"primary_key;column:bill_id"`
	UserID        int       `gorm:"column:user_id"`
	Amount        float64   `gorm:"column:amount"`
	CreatedAt     time.Time `gorm:"column:created_at"`
	DueDate       time.Time `gorm:"column:due_date"`
	Paid          bool      `gorm:"column:paid"`
	BillingPeriod string    `gorm:"column:billing_period"` // 新增字段
}
