package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetHistory(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从中间件中获取已认证用户的ID
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
		"PageNum":  int(form.PageSize),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeHistory, err := feeService.GetFeeHistory(userID, form.PageSize, form.PageNum)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	return model.SendSuccessResponse(c, feeHistory)
}
