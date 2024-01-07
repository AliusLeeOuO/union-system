package dto_admin

import "time"

// ViewAssistanceRequest 定义了查看特定工单请求的数据结构
type ViewAssistanceRequest struct {
	RequestID uint `json:"request_id" form:"request_id"`
}

type AssistanceResponse struct {
	ResponderID  uint      `json:"responder_id"`
	ResponseText string    `json:"response_text"`
	CreatedAt    time.Time `json:"created_at"`
}

type AssistanceStatusResponse struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
}

// ViewAssistanceResponse 定义了查看特定工单响应的数据结构
type ViewAssistanceResponse struct {
	// 根据实际情况添加所需字段
	ID             uint                     `json:"id"`
	AssistanceType string                   `json:"assistance_type"`
	Title          string                   `json:"title"`
	Description    string                   `json:"description"`
	Status         AssistanceStatusResponse `json:"status"`
	Responses      []AssistanceResponse     `json:"responses"`
}

type ReplyAssistanceRequest struct {
	RequestID    uint   `json:"request_id" form:"request_id"`
	ResponseText string `json:"response_text" form:"response_text"`
	NewStatusID  uint   `json:"new_status_id" form:"new_status_id"`
}

type ReplyAssistanceResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}
