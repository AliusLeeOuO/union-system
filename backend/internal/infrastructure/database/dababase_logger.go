package database

import (
	"context"
	"gorm.io/gorm/logger"
	"time"
	"union-system/global"
)

// LogrusLogger 是一个自定义的 GORM 日志处理器
type LogrusLogger struct {
	LogLevel logger.LogLevel
}

// 实现 logger.Interface 的方法 ...

func (l *LogrusLogger) LogMode(level logger.LogLevel) logger.Interface {
	newLogger := *l
	newLogger.LogLevel = level
	return &newLogger
}

func (l LogrusLogger) Info(ctx context.Context, msg string, data ...interface{}) {
	if l.LogLevel >= logger.Info {
		global.Logger.WithContext(ctx).Infof(msg, data...)
	}
}

func (l LogrusLogger) Warn(ctx context.Context, msg string, data ...interface{}) {
	if l.LogLevel >= logger.Warn {
		global.Logger.WithContext(ctx).Warnf(msg, data...)
	}
}

func (l LogrusLogger) Error(ctx context.Context, msg string, data ...interface{}) {
	if l.LogLevel >= logger.Error {
		global.Logger.WithContext(ctx).Errorf(msg, data...)
	}
}

func (l LogrusLogger) Trace(ctx context.Context, begin time.Time, fc func() (string, int64), err error) {
	if l.LogLevel <= logger.Silent {
		return
	}

	elapsed := time.Since(begin)
	sql, rows := fc()

	if err != nil {
		global.Logger.WithContext(ctx).WithError(err).Errorf("%s [%v] [rows: %d]", sql, elapsed, rows)
	} else if l.LogLevel >= logger.Warn && elapsed > time.Second {
		global.Logger.WithContext(ctx).Warnf("%s [%v] [rows: %d]", sql, elapsed, rows)
	} else if l.LogLevel >= logger.Info {
		global.Logger.WithContext(ctx).Infof("%s [%v] [rows: %d]", sql, elapsed, rows)
	}
}
