package user

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/user/user_handlers"
	"union-system/internal/api/middlewares"
)

func Init(app *fiber.App) {
	user := app.Group("/user")

	user.Get("/getCaptcha", user_handlers.GetCaptchaHandler)
	user.Post("/login", user_handlers.LoginHandler)

	// 注册验证中间件
	user.Use(middlewares.TokenAuth)
	user.Get("/getUserInfo", user_handlers.GetUserInfoHandler)
}
