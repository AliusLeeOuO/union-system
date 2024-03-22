package dto

import "union-system/internal/model"

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

type ActivityResponse struct {
	ActivityID        uint   `json:"activityId"`
	Title             string `json:"title"`
	Description       string `json:"description"`
	StartTime         string `json:"startTime"`
	EndTime           string `json:"endTime"`
	Location          string `json:"location"`
	MaxParticipants   uint   `json:"maxParticipants"`
	ActivityTypeID    uint   `json:"activityTypeId"`
	ActivityTypeName  string `json:"activityTypeName"`
	IsActive          bool   `json:"isActive"`
	RegistrationCount uint   `json:"registrationCount"`
}

type ActivityRegistrationResponse struct {
	UserId   uint   `json:"userId"`
	UserName string `json:"userName"`
	Phone    string `json:"phone"`
	Email    string `json:"email"`
}

type ActivityDetailManagementResponse struct {
	ActivityResponse `json:"activity"`
	Registrations    []ActivityRegistrationResponse `json:"registrations"`
}

type ActivityDetailResponse struct {
	ActivityResponse `json:"activity"`
	IsRegistered     bool `json:"isRegistered"`
}

type UserGetActivityListResponse struct {
	PageResponse
	Data []ActivityResponse `json:"data"`
}

// UserGetRegisteredActivityListResponse 用于返回用户已报名活动列表的响应
type UserGetRegisteredActivityListResponse struct {
	PageResponse
	Data []ActivityResponse `json:"data"`
}

// UnregisterUserRegisterRequest 用于取消用户报名活动的请求
type UnregisterUserRegisterRequest struct {
	ActivityID uint `json:"activityId" form:"activity_id"`
	UserId     uint `json:"userId" form:"user_id"`
}

// DropActivityRequest 用于删除活动的请求
type DropActivityRequest struct {
	Password string `json:"password" form:"password"`
}

// ChangeActivityTitleRequest 用于修改活动标题的请求
type ChangeActivityTitleRequest struct {
	ActivityID uint   `json:"activityId" form:"activity_id"`
	Title      string `json:"title" form:"title"`
}

// ChangeActivityDescriptionRequest 用于修改活动描述的请求
type ChangeActivityDescriptionRequest struct {
	ActivityID  uint   `json:"activityId" form:"activity_id"`
	Description string `json:"description" form:"description"`
}

// ChangeActivityLocationRequest 用于修改活动地点的请求
type ChangeActivityLocationRequest struct {
	ActivityID uint   `json:"activityId" form:"activity_id"`
	Location   string `json:"location" form:"location"`
}

type ActivityDetailWithRegistrationsResponse struct {
	model.Activity
	RegistrationCount uint `json:"registration_count"`
}
