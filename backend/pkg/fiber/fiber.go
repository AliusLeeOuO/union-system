package fiber

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/interfaces/handlers"
	"union-system/internal/interfaces/middlewares"
)

func InitFiber(servicePort int) {
	app := fiber.New()

	// 注册中间件
	app.Use(middlewares.RegisterCORS())

	// 调用 SetupRoutes 来添加所有定义的路由
	handlers.SetupRoutes(app)

	err := app.Listen(fmt.Sprintf("0.0.0.0:%v", servicePort))
	if err != nil {
		global.Logger.Panic("fiber lost: %v", err)
	}
}
