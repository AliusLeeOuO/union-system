package admin_assistance

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
	"union-system/utils/logModelEnum"
)

func ReplyAssistance(c *fiber.Ctx) error {
	var form dto.ReplyAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"RequestID":    int(form.RequestID),
		"ResponseText": form.ResponseText,
		"NewStatusID":  form.NewStatusID,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 业务逻辑处理
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.ReplyAssistance(form.RequestID, userID, form.ResponseText, form.NewStatusID); err != nil {
		return model.SendFailureResponse(c, model.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("回复援助，援助ID: %d", form.RequestID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ASSISTANCE)

	return model.SendSuccessResponse(c, nil)
}
