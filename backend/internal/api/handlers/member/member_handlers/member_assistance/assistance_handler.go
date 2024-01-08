package member_assistance

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	assistance := app.Group("/assistance")

	// 注册路由
	assistance.Post("/new", NewAssistance)
	assistance.Post("/reply", UserReplyAssistance)
	assistance.Post("/close", CloseAssistance)
}
