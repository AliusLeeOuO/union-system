package domain

type FeeStandardNew struct {
	StandardId     uint   `gorm:"primary_key;column:standard_id"`
	StandardName   string `gorm:"column:standard_name"`
	StandardAmount string `gorm:"column:standard_amount"`
}
