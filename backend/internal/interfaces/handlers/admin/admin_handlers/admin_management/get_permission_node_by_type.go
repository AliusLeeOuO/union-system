package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetPermissionNodeByType(c *fiber.Ctx) error {
	permissionType := c.Params("type")
	if permissionType != "ADMIN" && permissionType != "MEMBER" {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	permissionNodes, err := adminService.GetPermissionNodeByType(permissionType)
	if err != nil {
		return models.SendFailureResponse(c, models.ResourceNotFoundCode)
	}
	if len(permissionNodes) == 0 {
		return models.SendSuccessResponse(c, []interface{}{})
	}
	return models.SendSuccessResponse(c, permissionNodes)
}
