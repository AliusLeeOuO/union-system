package domain

// UserActivity tb_user_activity
type UserActivity struct {
	UserID     uint `gorm:"primary_key;column:user_id"`
	ActivityID uint `gorm:"primary_key;column:activity_id"`
}
