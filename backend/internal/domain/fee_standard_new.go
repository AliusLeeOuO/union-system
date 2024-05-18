package domain

type FeeStandardNew struct {
	StandardId     uint   `gorm:"primary_key;column:standard_id" json:"standard_id,omitempty"`
	StandardName   string `gorm:"column:standard_name" json:"standard_name,omitempty"`
	StandardAmount string `gorm:"column:standard_amount" json:"standard_amount,omitempty"`
}
