package admin_assistance

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	assistance := app.Group("/assistance")
	// 注册路由
	assistance.Post("/requests", GetAssistanceList)
	assistance.Get("/type", GetAssistanceType)
	assistance.Post("/type", NewAssistanceType)
	assistance.Delete("/type/:typeId", DeleteType)
	assistance.Post("/viewAssistance", ViewAssistance)
	assistance.Post("/replyAssistance", ReplyAssistance)
}
