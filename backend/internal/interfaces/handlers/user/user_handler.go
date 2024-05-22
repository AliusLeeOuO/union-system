package user

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/interfaces/handlers/user/user_handlers"
	"union-system/internal/interfaces/middlewares"
)

func Init(app *fiber.App) {
	user := app.Group("/user")

	user.Get("/getCaptcha", user_handlers.GetCaptchaHandler)
	user.Post("/login", user_handlers.LoginHandler)
	user.Post("/register", user_handlers.RegisterUserHandler)

	// 注册验证中间件
	user.Use(middlewares.TokenAuth)
	user.Get("/getUserInfo", user_handlers.GetUserInfoHandler)
	user.Post("/changePassword", user_handlers.ChangePasswordHandler)
	user.Post("/logout", user_handlers.LogoutHandler)
	user.Post("/uploadFile", user_handlers.UploadHandler)
	user.Get("/permission", user_handlers.GetPermissions)
}
