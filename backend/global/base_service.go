package global

import (
	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
	"github.com/robfig/cron/v3"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

var (
	Database     *gorm.DB
	Logger       *logrus.Logger
	RedisClient  *redis.Client
	FiberService *fiber.App
	Cron         *cron.Cron
)
