package admin

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/admin/admin_handlers/admin_activity"
	"union-system/internal/api/handlers/admin/admin_handlers/admin_assistance"
	"union-system/internal/api/handlers/admin/admin_handlers/admin_fee"
	"union-system/internal/api/handlers/admin/admin_handlers/admin_management"
	"union-system/internal/api/middlewares"
)

func Init(app *fiber.App) {
	admin := app.Group("/admin")

	// 注册验证中间件
	admin.Use(middlewares.TokenAuth)
	admin.Use(middlewares.RoleAuthAdmin)

	admin_assistance.Init(admin)
	admin_activity.Init(admin)
	admin_management.Init(admin)
	admin_fee.Init(admin)
}
