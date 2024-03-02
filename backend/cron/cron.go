package cron

import (
	"github.com/robfig/cron/v3"
	"union-system/cron/cronFunc"
	"union-system/global"
)

func InitCron() {
	// 创建一个新的cron实例
	c := cron.New()

	// 添加定时任务
	// 这里的"0 0 1 * *"表示每月1号的00:00执行
	c.AddFunc("0 0 1 * *", cronFunc.GetNewBills)

	c.Start()
	global.Logger.Info("Cron started")
}