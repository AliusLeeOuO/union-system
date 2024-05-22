package domain

import "time"

// AssistanceResponse 对应于 tb_assistance_response
type AssistanceResponse struct {
	ResponseID   uint      `gorm:"primary_key;column:response_id"`
	RequestID    uint      `gorm:"column:request_id"`
	ResponderID  uint      `gorm:"column:responder_id"`
	ResponseText string    `gorm:"column:response_text"`
	CreatedAt    time.Time `gorm:"column:created_at"`
	// 添加User字段以关联User模型
	User User `gorm:"foreignKey:ResponderID;references:UserID"`
}
