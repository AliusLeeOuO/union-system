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

func PayForFee(c *fiber.Ctx) error {
	// 获取表单数据
	var form dto.PayForFeeRequest
	// 解析请求体
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"bill_id": form.BillID,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 调用Service层进行支付处理
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err := feeService.PayFee(form.BillID)
	if err != nil {
		if err.Error() == "会费已支付，无需重复支付" {
			return model.SendFailureResponse(c, model.QueryParamErrorCode, "会费已支付，无需重复支付")
		}
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	return model.SendSuccessResponse(c, nil)
}
