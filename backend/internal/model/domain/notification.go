package domain

import "time"

// Notification tb_notification 表示系统中的通知
type Notification struct {
	NotificationID uint      `gorm:"primary_key;column:notification_id;autoIncrement"`
	Title          string    `gorm:"column:title;type:varchar(255);not null"`
	Content        string    `gorm:"column:content;type:text;not null"`
	CreatedAt      time.Time `gorm:"column:created_at;default:CURRENT_TIMESTAMP"`
	SenderID       *uint     `gorm:"column:sender_id"` // 可以为空，表示系统通知
}
