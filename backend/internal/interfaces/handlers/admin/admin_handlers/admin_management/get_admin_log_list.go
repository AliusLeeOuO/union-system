package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetAdminLogList(c *fiber.Ctx) error {
	var validate = validator.New()
	var req dto.LoginLogListRequest
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	if req.Status != "all" && req.Status != "true" && req.Status != "false" {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "status字段不合法")
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	logs, total, err := adminService.GetLogLoginsByPage(req.PageSize, req.PageNum, req.Status)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	// 返回分页响应
	return models.SendSuccessResponse(c, dto.GetLoginLogListResponse{
		PageResponse: dto.PageResponse{
			PageSize: req.PageSize,
			PageNum:  req.PageNum,
			Total:    total,
		},
		Data: logs,
	})
}
