package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type PermissionNodeRequest struct {
	ParentNode     uint   `json:"parent_node" form:"parent_node"`
	PermissionNode string `json:"permission_node" form:"permission_node" validate:"required"`
	Description    string `json:"description" form:"description" validate:"required"`
	PermissionType string `json:"permission_type" form:"permission_type" validate:"required"`
	PermissionName string `json:"permission_name" form:"permission_name" validate:"required"`
	ListOrder      uint   `json:"list_order" form:"list_order"`
	ListHidden     bool   `json:"list_hidden" form:"list_hidden"`
}

func NewPermissionNode(c *fiber.Ctx) error {
	var req PermissionNodeRequest
	var validate = validator.New()
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	err := adminService.NewPermissionNode(req.ParentNode, req.PermissionNode, req.Description, req.PermissionType, req.PermissionName, req.ListOrder, req.ListHidden)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	return models.SendSuccessResponse(c, nil)
}
