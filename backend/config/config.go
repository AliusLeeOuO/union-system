package config

import (
	"github.com/spf13/viper"
	"union-system/global"
)

// Config 结构体定义了整个应用的配置
type Config struct {
	App      AppConfig
	Database DatabaseConfig
	Redis    RedisConfig
}

// AppConfig 结构体定义了应用配置
type AppConfig struct {
	Port      int    `mapstructure:"port"`
	LogLevel  string `mapstructure:"log_level"`
	Debug     bool   `mapstructure:"debug"`
	SecretKey string `mapstructure:"secret_key"`
}

// DatabaseConfig 结构体定义了数据库配置
type DatabaseConfig struct {
	Host     string `mapstructure:"host"`
	Port     int    `mapstructure:"port"`
	User     string `mapstructure:"user"`
	Password string `mapstructure:"password"`
	Name     string `mapstructure:"name"`
}

// RedisConfig 结构体定义了 Redis 配置
type RedisConfig struct {
	Host     string `mapstructure:"host"`
	Port     int    `mapstructure:"port"`
	Password string `mapstructure:"password"`
	DB       int    `mapstructure:"db"`
}

func LoadConfig() *Config {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("./config/")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		global.Logger.Panic("Error reading config file: %s", err)
	}

	var config Config
	if err := viper.Unmarshal(&config); err != nil {
		global.Logger.Panic("Error unmarshalling config: %s", err)
	}

	return &config
}
