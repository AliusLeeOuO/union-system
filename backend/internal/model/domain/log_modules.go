package domain

// LogModules 对应于数据库中的 tb_log_modules 表
type LogModules struct {
	ModuleID   uint   `gorm:"primary_key;autoIncrement;column:module_id"`
	ModuleName string `gorm:"type:varchar(255);not null;unique;column:module_name"`
}
