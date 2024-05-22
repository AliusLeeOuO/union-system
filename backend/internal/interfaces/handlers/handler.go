package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/interfaces/handlers/admin"
	"union-system/internal/interfaces/handlers/member"
	"union-system/internal/interfaces/handlers/user"
)

func SetupRoutes(app *fiber.App) {
	app.Get("/ping", PingHandler)

	user.Init(app)
	admin.Init(app)
	member.Init(app)
}
