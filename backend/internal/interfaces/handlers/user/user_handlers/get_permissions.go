package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetPermissions(c *fiber.Ctx) error {
	// 获得用户ID
	userID := c.Locals("userID").(uint)
	// 初始化service并调用
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	permissions, err := userService.GetPermissions(c, userID)
	if err != nil {
		return err
	}
	return models.SendSuccessResponse(c, permissions)
}
