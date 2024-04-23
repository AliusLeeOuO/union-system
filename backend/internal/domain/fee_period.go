package domain

// FeePeriod tb_fee_period
type FeePeriod struct {
	PeriodID   uint   `gorm:"column:period_id;primary_key"`
	PeriodName string `gorm:"column:period_name"`
}
