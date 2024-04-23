package domain

import "time"

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
	FeeStandard      int       `gorm:"column:fee_standard"`
}
