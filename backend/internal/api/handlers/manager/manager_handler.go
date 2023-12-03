package manager

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/middlewares"
)

func Init(app *fiber.App) {
	manager := app.Group("/manager")

	// 注册验证中间件
	//manager.Use(TokenAuth)
	manager.Use(middlewares.RoleAuthManager)
}
