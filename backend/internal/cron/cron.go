package cron

import (
	"github.com/robfig/cron/v3"
	"union-system/internal/cron/cron_func"
)

func InitCron() {
	// 创建一个新的cron实例
	c := cron.New()

	// 添加定时任务
	c.AddFunc("0 0 1 * *", cron_func.GetNewBills)
	c.AddFunc("@every 1s", cron_func.SetCPUInfo)
	c.AddFunc("@every 1s", cron_func.SetMemoryInfo)

	c.Start()
}
