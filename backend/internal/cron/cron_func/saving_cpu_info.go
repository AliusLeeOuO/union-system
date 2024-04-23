package cron_func

import (
	"context"
	"fmt"
	"time"
	"union-system/global"

	"github.com/shirou/gopsutil/cpu"
)

// 更新或写入CPU信息
func SetCPUInfo() {
	ctx := context.Background()

	// 获取CPU信息
	info, err := cpu.Info()
	if err != nil {
		fmt.Println(err)
		return
	}

	// 获取逻辑CPU数量
	logicalCores, err := cpu.Counts(true)
	if err != nil {
		fmt.Println("获取逻辑CPU数量失败:", err)
		return
	}

	// 获取物理CPU核心数量
	physicalCores, err := cpu.Counts(false)
	if err != nil {
		fmt.Println("获取物理CPU核心数量失败:", err)
		return
	}

	// 获取CPU使用率
	percent, err := cpu.Percent(time.Second, false)
	if err != nil {
		fmt.Println(err)
		return
	}

	// 将结构体转换为map[string]interface{}以用于HSet
	// TODO: 待解决cores和trends疑似不正常
	data := map[string]interface{}{
		"models": info[0].ModelName,
		"cores":  physicalCores,
		"trends": logicalCores,
		"cache":  info[0].CacheSize,
		"usage":  fmt.Sprintf("%.2f", percent[0]),
		"idle":   fmt.Sprintf("%.2f", 100-percent[0]),
	}
	_, err = global.RedisClient.HSet(ctx, "cpu_info", data).Result()
	if err != nil {
		return
	}
}
