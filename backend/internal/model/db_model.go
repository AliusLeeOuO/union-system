package model

import (
	"time"
)

// Activity tb_activity
type Activity struct {
	ActivityID       uint      `gorm:"primary_key;column:activity_id"`
	ActivityName     string    `gorm:"column:activity_name"`
	Description      string    `gorm:"column:description"`
	StartTime        time.Time `gorm:"column:start_time"`
	EndTime          time.Time `gorm:"column:end_time"`
	Location         string    `gorm:"column:location"`
	ParticipantLimit uint      `gorm:"column:participant_limit"`
	ActivityTypeID   uint      `gorm:"column:activity_type_id"`
	CreatorID        uint      `gorm:"column:creator_id"`
	IsActive         bool      `gorm:"column:is_active"`
	Removed          bool      `gorm:"column:removed"`
}

// ActivityType tb_activity_type
type ActivityType struct {
	ActivityTypeID uint   `gorm:"primary_key;column:activity_type_id"`
	TypeName       string `gorm:"column:type_name"`
}

// AssistanceType tb_assistance_type
type AssistanceType struct {
	AssistanceTypeID uint   `gorm:"primary_key;column:assistance_type_id"`
	TypeName         string `gorm:"column:type_name"`
}

// Fee tb_fee
type Fee struct {
	FeeID         uint          `gorm:"primary_key;column:fee_id"`
	UserID        int           `gorm:"column:user_id"`
	Amount        float64       `gorm:"column:amount"`
	PaymentDate   time.Time     `gorm:"column:payment_date"`
	PeriodID      int           `gorm:"column:period_id"`
	PaymentMethod PaymentMethod `gorm:"foreignKey:PaymentMethodID"`
}

// FeePeriod tb_fee_period
type FeePeriod struct {
	PeriodID   uint   `gorm:"column:period_id;primary_key"`
	PeriodName string `gorm:"column:period_name"`
}

// FeeStandard tb_fee_standard
type FeeStandard struct {
	StandardID uint    `gorm:"column:standard_id;primaryKey;autoIncrement"`
	Amount     float64 `gorm:"column:amount;type:decimal(10,2);not null"`
	CategoryID uint    `gorm:"column:category_id"`
}

// MemberCategory tb_member_category
type MemberCategory struct {
	CategoryID uint   `gorm:"primaryKey;column:category_id;autoIncrement"`
	Name       string `gorm:"column:name;size:255;not null"`
}

// PaymentMethod tb_payment_method
type PaymentMethod struct {
	MethodID uint   `gorm:"primaryKey;column:method_id;autoIncrement"`
	Name     string `gorm:"column:name;size:255;not null"`
}

// FeeBill tb_fee_bill
type FeeBill struct {
	BillID        uint      `gorm:"primary_key;column:bill_id"`
	UserID        int       `gorm:"column:user_id"`
	Amount        float64   `gorm:"column:amount"`
	CreatedAt     time.Time `gorm:"column:created_at"`
	DueDate       time.Time `gorm:"column:due_date"`
	Paid          bool      `gorm:"column:paid"`
	BillingPeriod string    `gorm:"column:billing_period"` // 新增字段
}

// MemberInfo tb_member_info
type MemberInfo struct {
	InfoID   uint      `gorm:"primary_key;column:info_id"`
	UserID   int       `gorm:"unique;column:user_id"`
	Name     string    `gorm:"column:name"`
	Position string    `gorm:"column:position"`
	JoinDate time.Time `gorm:"column:join_date"`
}

// User tb_user
type User struct {
	UserID           uint      `gorm:"primary_key;column:user_id"`
	Username         string    `gorm:"column:username"`
	Password         string    `gorm:"column:password"`
	Email            string    `gorm:"column:email"`
	PhoneNumber      string    `gorm:"column:phone_number"`
	RegistrationDate time.Time `gorm:"column:registration_date"`
	UserTypeID       uint      `gorm:"column:user_type_id"`
	IsActive         bool      `gorm:"column:is_active"`
}

// MemberFeeInfo tb_member_fee_info
type MemberFeeInfo struct {
	InfoID        uint   `gorm:"primaryKey;column:info_id"`
	UserID        uint   `gorm:"column:user_id"`
	IsFeeActive   bool   `gorm:"column:is_fee_active"`
	FeeStartMonth string `gorm:"column:fee_start_month"`
}

// MemberDetails 对应于 tb_member_details
type MemberDetails struct {
	UserID        uint      `gorm:"primaryKey;column:user_id"`
	IsFeeActive   bool      `gorm:"column:is_fee_active;default:false"`
	FeeStartMonth time.Time `gorm:"column:fee_start_month"`
}

// UserActivity tb_user_activity
type UserActivity struct {
	UserID     uint `gorm:"primary_key;column:user_id"`
	ActivityID uint `gorm:"primary_key;column:activity_id"`
}

// UserType tb_user_type
type UserType struct {
	TypeID   uint   `gorm:"primary_key;column:type_id"`
	TypeName string `gorm:"column:type_name"`
}

// AssistanceStatus 对应于 tb_assistance_status
type AssistanceStatus struct {
	StatusID   uint   `gorm:"primary_key;column:status_id"`
	StatusName string `gorm:"column:status_name"`
}

// AssistanceRequest 对应于 tb_assistance_request
type AssistanceRequest struct {
	RequestID   uint      `gorm:"primary_key;column:request_id"`
	Title       string    `gorm:"column:title"`
	MemberID    uint      `gorm:"column:member_id"`
	StatusID    uint      `gorm:"column:status_id"`
	TypeID      uint      `gorm:"column:type_id"`
	Description string    `gorm:"column:description"`
	CreatedAt   time.Time `gorm:"column:created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at"`
	// 辅助字段
	AssistanceStatus AssistanceStatus `gorm:"foreignKey:status_id"`
	AssistanceType   AssistanceType   `gorm:"foreignKey:type_id"`
	User             User             `gorm:"foreignKey:MemberID;references:UserID"`
}

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

// AssistanceFeedback 对应于 tb_assistance_feedback
type AssistanceFeedback struct {
	FeedbackID uint      `gorm:"primary_key;column:feedback_id"`
	RequestID  uint      `gorm:"column:request_id"`
	MemberID   uint      `gorm:"column:member_id"`
	Rating     int       `gorm:"column:rating"`
	Comment    string    `gorm:"column:comment"`
	CreatedAt  time.Time `gorm:"column:created_at"`
}

// Notification tb_notification 表示系统中的通知
type Notification struct {
	NotificationID uint      `gorm:"primary_key;column:notification_id;autoIncrement"`
	Title          string    `gorm:"column:title;type:varchar(255);not null"`
	Content        string    `gorm:"column:content;type:text;not null"`
	CreatedAt      time.Time `gorm:"column:created_at;default:CURRENT_TIMESTAMP"`
	SenderID       *uint     `gorm:"column:sender_id"` // 可以为空，表示系统通知
}

// NotificationRecipient tb_notification_recipient 表示通知和接收者之间的关系
type NotificationRecipient struct {
	NotificationID uint `gorm:"primary_key;column:notification_id"`
	RecipientID    uint `gorm:"primary_key;column:recipient_id"`
	ReadStatus     bool `gorm:"column:read_status;default:false"` // 默认为未读
}

// LogLogin 对应于数据库中的 tb_log_login 表
type LogLogin struct {
	LogID       uint      `gorm:"primary_key;autoIncrement;column:log_id"`     // 日志ID，自增主键
	UA          string    `gorm:"type:text;not null;column:ua"`                // 用户代理字符串
	IP          string    `gorm:"type:varchar(39);not null;column:ip"`         // 用户的IP地址，兼容IPv4和IPv6格式
	LoginStatus bool      `gorm:"not null;column:login_status"`                // 登录状态
	LoginTime   time.Time `gorm:"default:CURRENT_TIMESTAMP;column:login_time"` // 登录时间
	Username    string    `gorm:"column:username"`                             // 用户名
}

// InvitationCodes 对应于数据库中的 tb_invitation_code 表 表示邀请码
type InvitationCodes struct {
	CodeID          uint      `gorm:"primary_key;autoIncrement;column:code_id"`
	Code            string    `gorm:"type:varchar(255);not null;unique;column:code"`
	CreatedByUserID uint      `gorm:"not null;column:created_by_user_id"`
	UsedByUserID    *uint     `gorm:"column:used_by_user_id"`
	IsUsed          bool      `gorm:"not null;column:is_used;default:false"`
	CreatedAt       time.Time `gorm:"column:created_at;default:CURRENT_TIMESTAMP"`
	ExpiresAt       time.Time `gorm:"not null;column:expires_at"`
}

// LogModules 对应于数据库中的 tb_log_modules 表
type LogModules struct {
	ModuleID   uint   `gorm:"primary_key;autoIncrement;column:module_id"`
	ModuleName string `gorm:"type:varchar(255);not null;unique;column:module_name"`
}

// LogAdmin 对应于数据库中的 tb_log_admin 表
type LogAdmin struct {
	LogID        uint      `gorm:"primary_key;autoIncrement;column:log_id"`
	UserId       uint      `gorm:"not null;column:user_id"`
	ModuleID     uint      `gorm:"not null;column:module_id"`
	IP           string    `gorm:"type:varchar(39);not null;column:ip"`
	ActionDetail string    `gorm:"type:text;not null;column:action_detail"`
	ActionTime   time.Time `gorm:"default:CURRENT_TIMESTAMP;column:action_time"`
}
