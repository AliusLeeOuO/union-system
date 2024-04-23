package middlewares

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func RegisterCORS() fiber.Handler {
	return cors.New(cors.Config{
		Next: nil,
		AllowOriginsFunc: func(origin string) bool {
			return origin != ""
		},
		AllowMethods:     "POST, GET, DELETE, OPTIONS",
		AllowHeaders:     "Content-Type, AccessToken, Authorization, Token",
		AllowCredentials: true,
		ExposeHeaders:    "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type",
		MaxAge:           0,
	})
}
