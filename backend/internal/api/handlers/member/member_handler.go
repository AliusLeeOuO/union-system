package member

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/member/member_handlers/member_activity"
	"union-system/internal/api/handlers/member/member_handlers/member_assistance"
	"union-system/internal/api/handlers/member/member_handlers/member_fee"
	"union-system/internal/api/handlers/member/member_handlers/member_notification"
	"union-system/internal/api/middlewares"
)

func Init(app *fiber.App) {
	member := app.Group("/member")

	// 注册验证中间件
	member.Use(middlewares.TokenAuth)
	member.Use(middlewares.RoleAuthMember)

	// 注册assistance路由
	member_assistance.Init(member)
	// 注册activity路由
	member_activity.Init(member)
	// 注册fee路由
	member_fee.Init(member)
	// 注册notification路由
	member_notification.Init(member)
}
