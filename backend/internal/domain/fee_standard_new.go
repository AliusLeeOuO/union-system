package domain

type FeeStandardNew struct {
	StandardId     uint   `gorm:"primary_key;column:standard_id"`
	StandardAmount string `gorm:"column:standard_amount"`
}
