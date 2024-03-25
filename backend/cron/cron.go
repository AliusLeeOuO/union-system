package cron

import (
	"union-system/cron/cronFunc"
	"union-system/global"

	"github.com/robfig/cron/v3"
)

func InitCron() {
	// 创建一个新的cron实例
	c := cron.New()

	// 添加定时任务
	c.AddFunc("0 0 1 * *", cronFunc.GetNewBills)
	c.AddFunc("@every 1s", cronFunc.SetCPUInfo)
	c.AddFunc("@every 1s", cronFunc.SetMemoryInfo)

	c.Start()
	global.Logger.Info("Cron started")
}
