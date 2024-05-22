package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetRoleGroup(c *fiber.Ctx) error {
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	roleGroup, err := userService.GetRoleGroupList()
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	return models.SendSuccessResponse(c, roleGroup)
}
