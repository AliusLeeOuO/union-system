package domain

import "time"

// LogAdmin 对应于数据库中的 tb_log_admin 表
type LogAdmin struct {
	LogID        uint      `gorm:"primary_key;autoIncrement;column:log_id"`
	UserId       uint      `gorm:"not null;column:user_id"`
	ModuleID     uint      `gorm:"not null;column:module_id"`
	IP           string    `gorm:"type:varchar(39);not null;column:ip"`
	ActionDetail string    `gorm:"type:text;not null;column:action_detail"`
	ActionTime   time.Time `gorm:"default:CURRENT_TIMESTAMP;column:action_time"`
}
