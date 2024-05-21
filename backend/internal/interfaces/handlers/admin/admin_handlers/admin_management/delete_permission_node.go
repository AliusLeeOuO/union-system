package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func DeletePermissionNode(c *fiber.Ctx) error {
	nodeIdString := c.Params("nodeId")
	nodeId, err := strconv.ParseUint(nodeIdString, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	err = adminService.DeletePermissionNode(uint(nodeId))
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	return models.SendSuccessResponse(c, nil)
}
