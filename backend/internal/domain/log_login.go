package domain

import "time"

// LogLogin 对应于数据库中的 tb_log_login 表
type LogLogin struct {
	LogID       uint      `gorm:"primary_key;autoIncrement;column:log_id"`     // 日志ID，自增主键
	UA          string    `gorm:"type:text;not null;column:ua"`                // 用户代理字符串
	IP          string    `gorm:"type:varchar(39);not null;column:ip"`         // 用户的IP地址，兼容IPv4和IPv6格式
	LoginStatus bool      `gorm:"not null;column:login_status"`                // 登录状态
	LoginTime   time.Time `gorm:"default:CURRENT_TIMESTAMP;column:login_time"` // 登录时间
	Username    string    `gorm:"column:username"`                             // 用户名
}
