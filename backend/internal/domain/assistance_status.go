package domain

// AssistanceStatus 对应于 tb_assistance_status
type AssistanceStatus struct {
	StatusID   uint   `gorm:"primary_key;column:status_id"`
	StatusName string `gorm:"column:status_name"`
}
