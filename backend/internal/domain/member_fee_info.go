package domain

// MemberFeeInfo tb_member_fee_info
type MemberFeeInfo struct {
	InfoID        uint   `gorm:"primary_key;column:info_id"`
	UserID        uint   `gorm:"column:user_id"`
	IsFeeActive   bool   `gorm:"column:is_fee_active"`
	FeeStartMonth string `gorm:"column:fee_start_month"`
}
