package domain

// ActivityType tb_activity_type
type ActivityType struct {
	ActivityTypeID uint   `gorm:"primary_key;column:activity_type_id"`
	TypeName       string `gorm:"column:type_name"`
	DelFlag        bool   `gorm:"column:del_flag"`
}
