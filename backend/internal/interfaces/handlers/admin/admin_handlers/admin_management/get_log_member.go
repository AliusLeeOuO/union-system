package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetLogMember(c *fiber.Ctx) error {
	// 获取表单数据
	var validate = validator.New()
	var form dto2.Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	logs, total, err := adminService.GetLogMembersByPage(form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.SystemErrorCode)
	}
	var res = dto2.GetMemberLogListResponse{
		PageResponse: dto2.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
		Data: logs,
	}
	return models.SendSuccessResponse(c, res)
}
