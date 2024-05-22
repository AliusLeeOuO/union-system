package domain

// AssistanceType tb_assistance_type
type AssistanceType struct {
	AssistanceTypeID uint   `gorm:"primary_key;column:assistance_type_id"`
	TypeName         string `gorm:"column:type_name"`
	DelFlag          bool   `gorm:"column:del_flag"`
}
