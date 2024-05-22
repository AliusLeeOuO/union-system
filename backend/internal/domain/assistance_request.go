package domain

import "time"

// AssistanceRequest 对应于 tb_assistance_request
type AssistanceRequest struct {
	RequestID   uint      `gorm:"primary_key;column:request_id"`
	Title       string    `gorm:"column:title"`
	MemberID    uint      `gorm:"column:member_id"`
	StatusID    uint      `gorm:"column:status_id"`
	TypeID      uint      `gorm:"column:type_id"`
	Description string    `gorm:"column:description"`
	CreatedAt   time.Time `gorm:"column:created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at"`
	// 辅助字段
	AssistanceStatus AssistanceStatus `gorm:"foreignKey:status_id"`
	AssistanceType   AssistanceType   `gorm:"foreignKey:type_id"`
	User             User             `gorm:"foreignKey:MemberID;references:UserID"`
}
