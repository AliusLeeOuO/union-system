package domain

// FeeStandard tb_fee_standard
type FeeStandard struct {
	StandardID uint    `gorm:"column:standard_id;primaryKey;autoIncrement"`
	Amount     float64 `gorm:"column:amount;type:decimal(10,2);not null"`
	CategoryID uint    `gorm:"column:category_id"`
}
