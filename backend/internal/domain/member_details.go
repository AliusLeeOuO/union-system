package domain

import "time"

// MemberDetails 对应于 tb_member_details
type MemberDetails struct {
	UserID        uint      `gorm:"primary_key;column:user_id"`
	IsFeeActive   bool      `gorm:"column:is_fee_active;default:false"`
	FeeStartMonth time.Time `gorm:"column:fee_start_month"`
}
