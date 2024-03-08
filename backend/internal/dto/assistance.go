package dto

import "time"

// admin dto

// ViewAssistanceRequest 定义了查看特定工单请求的数据结构
type ViewAssistanceRequest struct {
	RequestID uint `json:"request_id" form:"request_id"`
}

type AssistanceResponse struct {
	ResponseID   uint      `json:"response_id"`
	ResponderID  uint      `json:"responder_id"`
	ResponseText string    `json:"response_text"`
	CreatedAt    time.Time `json:"created_at"`
	Username     string    `json:"username"`
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
	CreatedAt      string                   `json:"created_at"`
	UpdatedAt      string                   `json:"updated_at"`
	Status         AssistanceStatusResponse `json:"status"`
	Type           GetAssistanceTypeRequest `json:"type"`
	Responses      []AssistanceResponse     `json:"responses"`
}

type ReplyAssistanceRequest struct {
	RequestID    uint   `json:"request_id" form:"request_id"`
	ResponseText string `json:"response_text" form:"response_text"`
	NewStatusID  uint   `json:"new_status_id" form:"new_status_id"`
}

// member dto

// NewAssistanceRequest 接收发起工单请求的数据结构
type NewAssistanceRequest struct {
	TypeID      uint   `json:"type_id" form:"type_id"`
	Title       string `json:"title" form:"title"`
	Description string `json:"description" form:"description"`
}

type UserReplyAssistanceRequest struct {
	RequestID    uint   `json:"request_id" form:"request_id"`
	ResponseText string `json:"response_text" form:"response_text"`
}

type CloseAssistanceRequest struct {
	RequestID uint `json:"request_id" form:"request_id"`
}

// MyAssistanceResponse 用于封装单个工单的详细信息
type MyAssistanceResponse struct {
	Title            string `json:"title"`
	AssistanceID     uint   `json:"assistance_id"`
	Description      string `json:"description"`
	RequestDate      string `json:"request_date"`
	AssistanceTypeID uint   `json:"assistance_type_id"`
	AssistanceType   string `json:"assistance_type"`
	StatusID         uint   `json:"status_id"`
}

// MyAssistancesListResponse 用于返回会员的工单列表和分页信息
type MyAssistancesListResponse struct {
	PageResponse
	AssistanceStatus   []AssistanceStatusDTO  `json:"assistance_status"`
	Assistances        []MyAssistanceResponse `json:"assistances"`
	ResolvedCount      uint                   `json:"resolved_count"`
	PendingReviewCount uint                   `json:"pending_review_count"`
}

// AssistanceStatusDTO 用于封装状态ID和状态名称
type AssistanceStatusDTO struct {
	StatusID   uint   `json:"status_id"`
	StatusName string `json:"status_name"`
}
