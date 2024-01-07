package model

import "time"

// Activity tb_activity
type Activity struct {
	ActivityID       uint      `gorm:"primary_key;column:activity_id"`
	ActivityName     string    `gorm:"column:activity_name"`
	Description      string    `gorm:"column:description"`
	StartTime        time.Time `gorm:"column:start_time"`
	EndTime          time.Time `gorm:"column:end_time"`
	Location         string    `gorm:"column:location"`
	ParticipantLimit int       `gorm:"column:participant_limit"`
	ActivityTypeID   int       `gorm:"column:activity_type_id"`
	CreatorID        int       `gorm:"column:creator_id"`
}

// ActivityType tb_activity_type
type ActivityType struct {
	ActivityTypeID uint   `gorm:"primary_key;column:activity_type_id"`
	TypeName       string `gorm:"column:type_name"`
}

// Assistance tb_assistance
type Assistance struct {
	AssistanceID     uint      `gorm:"primary_key;column:assistance_id"`
	AssistanceTypeID int       `gorm:"column:assistance_type_id"`
	Description      string    `gorm:"column:description"`
	RequestDate      time.Time `gorm:"column:request_date"`
	UserID           int       `gorm:"column:user_id"`
}

// AssistanceType tb_assistance_type
type AssistanceType struct {
	AssistanceTypeID uint   `gorm:"primary_key;column:assistance_type_id"`
	TypeName         string `gorm:"column:type_name"`
}

// Fee tb_fee
type Fee struct {
	FeeID       uint      `gorm:"primary_key;column:fee_id"`
	UserID      int       `gorm:"column:user_id"`
	Amount      float64   `gorm:"column:amount"`
	PaymentDate time.Time `gorm:"column:payment_date"`
	PeriodID    int       `gorm:"column:period_id"`
}

// FeePeriod tb_fee_period
type FeePeriod struct {
	PeriodID   uint   `gorm:"primary_key;column:period_id"`
	PeriodName string `gorm:"column:period_name"`
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
	RequestID      uint           `gorm:"primary_key;column:request_id"`
	MemberID       uint           `gorm:"column:member_id"`
	StatusID       uint           `gorm:"column:status_id"`
	TypeID         uint           `gorm:"column:type_id"`
	Description    string         `gorm:"column:description"`
	CreatedAt      time.Time      `gorm:"column:created_at"`
	UpdatedAt      time.Time      `gorm:"column:updated_at"`
	AssistanceType AssistanceType `gorm:"foreignKey:type_id"`
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
