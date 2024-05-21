package domain

// UserType tb_user_type
type UserType struct {
	TypeID           uint   `gorm:"primary_key;column:type_id" json:"type_id,omitempty"`
	TypeName         string `gorm:"column:type_name" json:"type_name,omitempty"`
	AllowAccountType string `gorm:"column:allow_account_type" json:"allow_account_type,omitempty"`
	Description      string `gorm:"column:description" json:"description,omitempty"`
}
