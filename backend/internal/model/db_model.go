package model

import (
	"time"
)

// Activity tb_activity
type Activity struct {
	ActivityID        uint      `gorm:"primary_key;column:activity_id"`
	ActivityName      string    `gorm:"column:activity_name"`
	Description       string    `gorm:"column:description"`
	StartTime         time.Time `gorm:"column:start_time"`
	EndTime           time.Time `gorm:"column:end_time"`
	Location          string    `gorm:"column:location"`
	ParticipantLimit  uint      `gorm:"column:participant_limit"`
	ActivityTypeID    uint      `gorm:"column:activity_type_id"`
	CreatorID         uint      `gorm:"column:creator_id"`
	IsActive          bool      `gorm:"column:is_active"`
	Removed           bool      `gorm:"column:removed"`
	RegistrationCount uint      `gorm:"column:registration_count"`
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

// Notification tb_notification
type Notification struct {
	NotificationID uint      `gorm:"primary_key;column:notification_id"`
	Title          string    `gorm:"column:title"`
	Content        string    `gorm:"column:content"`
	PublishTime    time.Time `gorm:"column:publish_time"`
	PublisherID    int       `gorm:"column:publisher_id"`
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
}

// AssistanceResponse 对应于 tb_assistance_response
type AssistanceResponse struct {
	ResponseID   uint      `gorm:"primary_key;column:response_id"`
	RequestID    uint      `gorm:"column:request_id"`
	ResponderID  uint      `gorm:"column:responder_id"`
	ResponseText string    `gorm:"column:response_text"`
	CreatedAt    time.Time `gorm:"column:created_at"`
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
