package config

import (
	"github.com/spf13/viper"
	"union-system/global"
)

// Config 结构体定义了整个应用的配置
type Config struct {
	App              AppConfig
	Redis            RedisConfig
	PostgreSQLConfig PostgreSQLConfig
}

// AppConfig 结构体定义了应用配置
type AppConfig struct {
	Port      int    `mapstructure:"port"`
	LogLevel  string `mapstructure:"log_level"`
	Debug     bool   `mapstructure:"debug"`
	SecretKey string `mapstructure:"secret_key"`
}

// PostgreSQLConfig 结构体定义了 PostgreSQL 配置
type PostgreSQLConfig struct {
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

var (
	Secret string
)

func LoadConfig() *Config {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("./")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		global.Logger.Panic("Error reading config file: %s", err)
	}

	var config Config
	if err := viper.Unmarshal(&config); err != nil {
		global.Logger.Panic("Error unmarshalling config: %s", err)
	}

	Secret = config.App.SecretKey

	return &config
}
