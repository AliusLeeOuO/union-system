package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/user"
)

func SetupRoutes(app *fiber.App) {
	app.Get("/ping", PingHandler)
	//app.Get("/captcha", user_handlers.GetCaptchaHandler)

	user.Init(app)
}
