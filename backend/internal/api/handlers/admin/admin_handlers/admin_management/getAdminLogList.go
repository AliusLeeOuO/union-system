package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetAdminLogList(c *fiber.Ctx) error {
	var validate = validator.New()
	var req dto.LoginLogListRequest
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	if req.Status != "all" && req.Status != "true" && req.Status != "false" {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "status字段不合法")
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	logs, total, err := adminService.GetLogLoginsByPage(req.PageSize, req.PageNum, req.Status)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	// 返回分页响应
	return model.SendSuccessResponse(c, dto.GetLoginLogListResponse{
		PageResponse: dto.PageResponse{
			PageSize: req.PageSize,
			PageNum:  req.PageNum,
			Total:    total,
		},
		Data: logs,
	})
}
