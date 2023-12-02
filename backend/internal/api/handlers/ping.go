package handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/model"
)

func PingHandler(c *fiber.Ctx) error {
	return model.SendSuccessResponse(c, "pong")
}
