package cron

import (
	"github.com/robfig/cron/v3"
	cronFunc2 "union-system/internal/cron/cron_func"
)

func InitCron() {
	// 创建一个新的cron实例
	c := cron.New()

	// 添加定时任务
	c.AddFunc("0 0 1 * *", cronFunc2.GetNewBills)
	c.AddFunc("@every 1s", cronFunc2.SetCPUInfo)
	c.AddFunc("@every 1s", cronFunc2.SetMemoryInfo)

	c.Start()
}
