package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/interfaces/models"
)

func PingHandler(c *fiber.Ctx) error {
	return models.SendSuccessResponse(c, "pong")
}
