package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func DeletePermissionGroup(c *fiber.Ctx) error {
	permissionGroupString := c.Params("permissionGroup")
	permissionGroupId, err := strconv.ParseUint(permissionGroupString, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	err = adminService.DeletePermissionGroup(uint(permissionGroupId))
	if err != nil {
		return models.SendFailureResponse(c, models.OperationFailedErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
