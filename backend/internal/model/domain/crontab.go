package domain

import "time"

type Crontab struct {
	CrontabID uint      `gorm:"primary_key;column:cron_id"`
	Name      string    `gorm:"column:name"`
	Spec      string    `gorm:"column:spec"`
	Active    bool      `gorm:"column:active"`
	LastRun   time.Time `gorm:"column:last_run"`
	GmtCreate time.Time `gorm:"column:gmt_create"`
	GmtUpdate time.Time `gorm:"column:gmt_update"`
	DelFlag   bool      `gorm:"column:del_flag"`
}
