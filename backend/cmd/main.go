package main

import (
	"fmt"
	"union-system/config"
	"union-system/internal/pkg/database"
	"union-system/internal/pkg/fiber"
	"union-system/internal/pkg/logger"
	"union-system/internal/pkg/redis"
)

func main() {
	fmt.Printf("Hello, World 👋!\n")

	initConfig := config.LoadConfig()
	logger.InitLogger()
	database.InitDatabase(initConfig.Database.Host, initConfig.Database.Port, initConfig.Database.User, initConfig.Database.Password, initConfig.Database.Name)
	redis.InitRedis(initConfig.Redis.Host, initConfig.Redis.Port, initConfig.Redis.Password, initConfig.Redis.DB)
	fiber.InitFiber(initConfig.App.Port)
}
