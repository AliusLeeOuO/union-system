package domain

import "time"

// InvitationCodes 对应于数据库中的 tb_invitation_code 表 表示邀请码
type InvitationCodes struct {
	CodeID          uint      `gorm:"primary_key;autoIncrement;column:code_id"`
	Code            string    `gorm:"type:varchar(255);not null;unique;column:code"`
	CreatedByUserID uint      `gorm:"not null;column:created_by_user_id"`
	UsedByUserID    *uint     `gorm:"column:used_by_user_id"`
	IsUsed          bool      `gorm:"not null;column:is_used;default:false"`
	CreatedAt       time.Time `gorm:"column:created_at;default:CURRENT_TIMESTAMP"`
	ExpiresAt       time.Time `gorm:"not null;column:expires_at"`
}
