package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/api/handlers/manager"
	"union-system/internal/api/handlers/user"
	"union-system/internal/api/middlewares"
)

func SetupRoutes(app *fiber.App) {
	app.Get("/ping", PingHandler)

	user.Init(app)
	app.Use(middlewares.TokenAuth)
	manager.Init(app)
}
