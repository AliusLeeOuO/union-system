package domain

import "time"

// MemberInfo tb_member_info
type MemberInfo struct {
	InfoID   uint      `gorm:"primary_key;column:info_id"`
	UserID   int       `gorm:"unique;column:user_id"`
	Name     string    `gorm:"column:name"`
	Position string    `gorm:"column:position"`
	JoinDate time.Time `gorm:"column:join_date"`
}
