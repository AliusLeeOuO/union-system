package dto

type ActivityListRequest struct {
	Pagination
}

type ActivityListResponse struct {
	PageResponse
	Activities []ActivityItem `json:"activities"`
}

type ActivityItem struct {
	ID          uint   `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	StartTime   string `json:"startTime"`
	EndTime     string `json:"endTime"`
	// 其他活动相关字段
}

// GetActivityTypeRequest 定义了获取活动类型列表请求的数据结构
type GetActivityTypeRequest struct {
	ActivityTypeId uint   `json:"activity_type_id"`
	TypeName       string `json:"type_name"`
}

type CreateOrModifyActivityRequest struct {
	Title           string `json:"title" form:"title"`
	Description     string `json:"description" form:"description"`
	StartTime       string `json:"startTime" form:"start_time"`
	EndTime         string `json:"endTime" form:"end_time"`
	Location        string `json:"location" form:"location"`
	Type            uint   `json:"type" form:"type"`
	MaxParticipants uint   `json:"maxParticipants" form:"max_participants"`
	IsActive        bool   `json:"isActive" form:"is_active"`
}

type CreateActivityResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	ID      uint   `json:"id"` // 新创建活动的ID
}

type EditActivityRequest struct {
	Name            string `json:"name"`
	Description     string `json:"description"`
	StartTime       string `json:"startTime"`
	EndTime         string `json:"endTime"`
	Location        string `json:"location"`
	MaxParticipants uint   `json:"maxParticipants"`
	ActivityTypeID  uint   `json:"activityTypeId"`
}
