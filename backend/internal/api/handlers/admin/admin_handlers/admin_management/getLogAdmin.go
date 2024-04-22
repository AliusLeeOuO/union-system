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

func GetLogAdmin(c *fiber.Ctx) error {
	// 获取表单数据
	var validate = validator.New()
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	logs, total, err := adminService.GetLogAdminsByPage(form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.SystemErrorCode)
	}
	var res = dto.GetAdminLogListResponse{
		PageResponse: dto.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
		Data: logs,
	}
	return model.SendSuccessResponse(c, res)
}
