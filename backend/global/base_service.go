package global

import (
	"github.com/redis/go-redis/v9"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

var (
	Database    *gorm.DB
	Logger      *logrus.Logger
	RedisClient *redis.Client
)
