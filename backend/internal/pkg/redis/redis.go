package redis

import (
	"context"
	"fmt"
	"github.com/redis/go-redis/v9"
	"union-system/global"
)

func InitRedis(host string, port int, password string, db int) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%v:%v", host, port),
		Password: password,
		DB:       db,
	})

	// 测试 Redis 连接
	ctx := context.Background()
	pong, err := rdb.Ping(ctx).Result()
	if err != nil {
		// 连接错误处理
		global.Logger.Panicf("Failed to connect to Redis: %v", err)
	}

	// 如果响应是 "PONG"，则表示连接成功
	if pong != "PONG" {
		global.Logger.Panicf("Unexpected response from Redis: %v", pong)
	}

	global.Logger.Info("Redis connected successfully")

	global.RedisClient = rdb
}
