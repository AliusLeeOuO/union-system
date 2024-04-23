package dto

import (
	"time"
	"union-system/internal/model/domain"
)

type NotificationInstance struct {
	NotificationID uint      `json:"notification_id"`
	Title          string    `json:"title"`
	Content        string    `json:"content"`
	CreatedAt      time.Time `json:"created_at"`
	ReadStatus     bool      `json:"read_status"`
	SenderName     string    `json:"sender_name"`
	SenderRole     uint      `json:"sender_role"`
}

type NotificationPageResponse struct {
	PageResponse
	Notifications []NotificationInstance `json:"notifications"`
}

type NotificationWithReadStatus struct {
	domain.Notification
	ReadStatus bool
	SenderName string `json:"sender_name"`
	SenderRole uint   `json:"sender_role"`
}
