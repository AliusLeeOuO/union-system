package database

import (
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gorm.io/gorm/schema"
	"union-system/global"
)

var DB *gorm.DB

func InitDatabase(dbHost string, dbPort int, dbUser string, dbPassword string, dbName string) {
	dsn := fmt.Sprintf("%v:%v@tcp(%v:%v)/%v?charset=utf8mb4&parseTime=True&loc=Local", dbUser, dbPassword, dbHost, dbPort, dbName)

	// 初始化GORM日志配置
	newLogger := &LogrusLogger{LogLevel: logger.Info} // 设置为您需要的日志级别

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		Logger:         newLogger,
		NamingStrategy: schema.NamingStrategy{SingularTable: true},
	})
	sqlDB, err := db.DB()
	if err != nil {
		global.Logger.Panic("mysql lost: %v", err)
	}

	//设置连接池
	//空闲
	sqlDB.SetMaxIdleConns(10)
	//打开
	sqlDB.SetMaxOpenConns(20)

	global.Database = db
}
