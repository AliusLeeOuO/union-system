package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type PermissionGroupRequest struct {
	RoleId uint `json:"role_id" form:"role_id" validate:"required"`
}

func GetPermissionGroup(c *fiber.Ctx) error {
	var req PermissionGroupRequest
	var validate = validator.New()
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		req.RoleId = 0
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	permissionGroupList, err := adminService.GetPermissions(req.RoleId)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	if len(permissionGroupList) == 0 {
		return models.SendSuccessResponse(c, []interface{}{})
	}
	return models.SendSuccessResponse(c, permissionGroupList)
}
