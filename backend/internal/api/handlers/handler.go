package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/admin"
	"union-system/internal/api/handlers/user"
)

func SetupRoutes(app *fiber.App) {
	app.Get("/ping", PingHandler)

	user.Init(app)
	admin.Init(app)
}
