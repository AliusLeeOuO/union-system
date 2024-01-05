package database

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gorm.io/gorm/schema"
	"union-system/global"
)

func InitDatabase(dbHost string, dbPort int, dbUser string, dbPassword string, dbName string) {
	dsn := fmt.Sprintf("host=%v user=%v password=%v dbname=%v port=%v sslmode=disable TimeZone=Asia/Shanghai", dbHost, dbUser, dbPassword, dbName, dbPort)
	// 初始化GORM日志配置
	newLogger := &LogrusLogger{LogLevel: logger.Info} // 设置为您需要的日志级别

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: newLogger,
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
			TablePrefix:   "tb_",
		},
	})
	sqlDB, err := db.DB()
	if err != nil {
		global.Logger.Panic("sql lost: %v", err)
	}

	//设置连接池
	//空闲
	sqlDB.SetMaxIdleConns(10)
	//打开
	sqlDB.SetMaxOpenConns(20)

	global.Database = db
}
