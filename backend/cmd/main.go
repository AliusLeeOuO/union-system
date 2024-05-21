package main

import (
	"fmt"
	"runtime"
	"union-system/internal/cron"
	"union-system/internal/cron/cron_func"
	"union-system/internal/infrastructure/config"
	"union-system/internal/infrastructure/database"
	"union-system/internal/infrastructure/redis"
	"union-system/pkg/fiber"
	"union-system/pkg/logger"
)

func main() {
	fmt.Printf("Hello, World 👋!\n")

	fmt.Printf("union-system serve\n")
	fmt.Printf("Build with Go(%v %v/%v)\n\n\n", runtime.Version(), runtime.GOOS, runtime.GOARCH)

	initConfig := config.LoadConfig()
	logger.InitLogger()
	database.InitDatabase(initConfig.PostgreSQLConfig.Host, initConfig.PostgreSQLConfig.Port, initConfig.PostgreSQLConfig.User, initConfig.PostgreSQLConfig.Password, initConfig.PostgreSQLConfig.Name)
	redis.InitRedis(initConfig.Redis.Host, initConfig.Redis.Port, initConfig.Redis.Password, initConfig.Redis.DB)
	// 初始化定时任务
	cron.InitCron()
	cron_func.GetNewBills()
	fiber.InitFiber(initConfig.App.Port)
}
