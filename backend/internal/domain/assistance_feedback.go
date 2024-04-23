package domain

import "time"

// AssistanceFeedback 对应于 tb_assistance_feedback
type AssistanceFeedback struct {
	FeedbackID uint      `gorm:"primary_key;column:feedback_id"`
	RequestID  uint      `gorm:"column:request_id"`
	MemberID   uint      `gorm:"column:member_id"`
	Rating     int       `gorm:"column:rating"`
	Comment    string    `gorm:"column:comment"`
	CreatedAt  time.Time `gorm:"column:created_at"`
}
