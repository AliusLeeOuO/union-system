package domain

import "time"

// LogMember 对应于数据库中的 tb_log_member 表
type LogMember struct {
	LogID        uint      `gorm:"primary_key;autoIncrement;column:log_id"`
	ModuleId     uint      `gorm:"not null;column:module_id"`
	Ip           string    `gorm:"type:varchar(39);not null;column:ip"`
	ActionDetail string    `gorm:"type:text;not null;column:action_detail"`
	ActionTime   time.Time `gorm:"not null;column:action_time"`
	UserID       uint      `gorm:"not null;column:user_id"`
}
