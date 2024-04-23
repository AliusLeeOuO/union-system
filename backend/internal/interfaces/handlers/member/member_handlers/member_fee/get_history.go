package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/check_fields"
)

func GetHistory(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从中间件中获取已认证用户的ID
	// 获取表单数据
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return models.SendFailureResponse(c, models.QueryParamErrorCode, errorMessage)
	}
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeHistory, err := feeService.GetFeeHistory(userID, form.PageSize, form.PageNum)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	return models.SendSuccessResponse(c, feeHistory)
}
