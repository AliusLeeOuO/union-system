package cron_func

import (
	"context"
	"fmt"
	"union-system/global"

	"github.com/shirou/gopsutil/mem"
)

// 更新或写入内存信息
func SetMemoryInfo() {
	ctx := context.Background()

	// 获取物理内存状态
	vmStat, err := mem.VirtualMemory()
	if err != nil {
		fmt.Println("获取内存信息失败:", err)
		return
	}

	// 由于Total和Available都是关于物理内存的，因此它们可以用来计算物理内存的使用情况
	// 计算已使用的物理内存（单位：MB）
	usedPhysicalMemory := vmStat.Total - vmStat.Available
	// 空闲的物理内存（单位：MB）
	freePhysicalMemory := vmStat.Available

	// 将结构体转换为map[string]interface{}以用于HSet
	data := map[string]interface{}{
		"total": vmStat.Total,
		"used":  usedPhysicalMemory,
		"free":  freePhysicalMemory,
		"usage": fmt.Sprintf("%.2f", vmStat.UsedPercent),
	}
	_, err = global.RedisClient.HSet(ctx, "memory_info", data).Result()
	if err != nil {
		return
	}
}
