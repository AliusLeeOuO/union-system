package domain

// UserType tb_user_type
type UserType struct {
	TypeID   uint   `gorm:"primary_key;column:type_id"`
	TypeName string `gorm:"column:type_name"`
}
