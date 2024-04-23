package domain

import "time"

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
