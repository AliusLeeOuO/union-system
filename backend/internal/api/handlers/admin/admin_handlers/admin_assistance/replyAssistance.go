package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto/dto_admin"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func ReplyAssistance(c *fiber.Ctx) error {
	var form dto_admin.ReplyAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)
	form.ResponderID = userID // 设置为当前登录用户的 ID

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"RequestID":    int(form.RequestID),
		"ResponseText": form.ResponseText,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 业务逻辑处理
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.ReplyAssistance(form); err != nil {
		return model.SendFailureResponse(c, model.OperationFailedErrorCode, err.Error())
	}

	response := dto_admin.ReplyAssistanceResponse{
		Success: true,
		Message: "Assistance replied successfully",
	}
	return model.SendSuccessResponse(c, response)
}
