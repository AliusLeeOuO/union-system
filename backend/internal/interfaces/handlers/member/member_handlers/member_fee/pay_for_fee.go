package member_fee

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/gofiber/fiber/v2"
)

// PayForFeeRequest 用于接收用户缴费请求
type PayForFeeRequest struct {
	BillID uint `json:"bill_id" form:"bill_id"` // 账单ID
}

func PayForFee(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint)
	var validate = validator.New()
	var form PayForFeeRequest
	// 解析请求体
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 调用Service层进行支付处理
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err := feeService.PayFee(userID, form.BillID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("会员支付了会费，账单ID: %d", form.BillID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.FEE)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	_ = notificationService.InsertNotificationBySystem("会费支付成功", "您已成功支付会费", c.Locals("userID").(uint))

	return models.SendSuccessResponse(c, nil)
}
