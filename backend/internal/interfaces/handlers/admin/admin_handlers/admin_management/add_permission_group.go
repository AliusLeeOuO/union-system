package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/validate_account_type"
)

type AddPermissionGroupRequest struct {
	TypeName      string `json:"type_name" form:"type_name" validate:"required"`
	Description   string `json:"description" form:"description" validate:"required"`
	AllowRoleType string `json:"allow_role_type" form:"allow_role_type" validate:"required,allowRoleType"`
}

func AddPermissionGroup(c *fiber.Ctx) error {
	var validate = validator.New()
	var request AddPermissionGroupRequest
	_ = validate.RegisterValidation("allowRoleType", validate_account_type.ValidateAccountType)
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	err := adminService.AddPermissionGroup(request.TypeName, request.Description, request.AllowRoleType)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	return models.SendSuccessResponse(c, nil)
}
