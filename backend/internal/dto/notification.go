package dto

import "time"

type NotificationInstance struct {
	NotificationID uint      `json:"notification_id"`
	Title          string    `json:"title"`
	Content        string    `json:"content"`
	CreatedAt      time.Time `json:"created_at"`
	ReadStatus     bool      `json:"read_status"`
}

type NotificationPageResponse struct {
	PageResponse
	Notifications []NotificationInstance `json:"notifications"`
}
