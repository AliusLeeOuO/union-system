package member_fee

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/check_fields"
	"union-system/utils/log_model_enum"

	"github.com/gofiber/fiber/v2"
)

func PayForFee(c *fiber.Ctx) error {
	// 获取表单数据
	var form dto.PayForFeeRequest
	// 解析请求体
	if err := c.BodyParser(&form); err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"bill_id": form.BillID,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return models.SendFailureResponse(c, models.QueryParamErrorCode, errorMessage)
	}

	// 调用Service层进行支付处理
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err := feeService.PayFee(form.BillID)
	if err != nil {
		if err.Error() == "会费已支付，无需重复支付" {
			return models.SendFailureResponse(c, models.QueryParamErrorCode, "会费已支付，无需重复支付")
		}
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("会员支付了会费，账单ID: %d", form.BillID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.FEE)

	return models.SendSuccessResponse(c, nil)
}
