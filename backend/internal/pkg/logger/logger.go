package logger

import (
	"github.com/sirupsen/logrus"
	"union-system/global"
)

func InitLogger() {
	var log = logrus.New()
	// 设置日志级别
	log.SetLevel(logrus.InfoLevel)
	// 设置日志格式
	log.SetFormatter(&logrus.JSONFormatter{})
	global.Logger = log
}
