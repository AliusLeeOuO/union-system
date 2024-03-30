package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetLogAdmin(c *fiber.Ctx) error {
	// 获取表单数据
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
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
