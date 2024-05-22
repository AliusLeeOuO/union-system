package domain

import "time"

// Fee tb_fee
type Fee struct {
	FeeID       uint      `gorm:"primary_key;column:fee_id"`
	UserID      int       `gorm:"column:user_id"`
	Amount      float64   `gorm:"column:amount"`
	PaymentDate time.Time `gorm:"column:payment_date"`
	PeriodID    int       `gorm:"column:period_id"`
	// 辅助字段
	PaymentMethod PaymentMethod `gorm:"foreignKey:PaymentMethodID"`
}
