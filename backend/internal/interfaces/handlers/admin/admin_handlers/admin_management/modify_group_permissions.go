package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type ModifyGroupPermissionsRequest struct {
	PermissionIds []uint `json:"permission_ids" form:"permission_ids" validate:"required"`
	GroupId       uint   `json:"group_id" form:"group_id" validate:"required"`
}

func ModifyGroupPermissions(c *fiber.Ctx) error {
	var validate = validator.New()
	var modifyReq ModifyGroupPermissionsRequest
	if err := c.BodyParser(&modifyReq); err != nil || validate.Struct(modifyReq) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	if err := adminService.ModifyGroupPermissions(modifyReq.PermissionIds, modifyReq.GroupId); err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
