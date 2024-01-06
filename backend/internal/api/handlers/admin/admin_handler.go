package admin

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/admin/admin_handlers"
	"union-system/internal/api/middlewares"
)

func Init(app *fiber.App) {
	admin := app.Group("/admin")

	// 注册验证中间件
	admin.Use(middlewares.TokenAuth)
	admin.Use(middlewares.RoleAuthAdmin)
	admin.Post("/getUserList", admin_handlers.GetUserList)
	admin.Post("/getAssistanceType", admin_handlers.GetAssistanceType)
}
