package admin_assistance

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func ReplyAssistance(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.ReplyAssistanceRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)

	// 业务逻辑处理
	assistanceService := service2.NewAssistanceService(repository2.NewAssistanceRepository(global.Database))
	if err := assistanceService.ReplyAssistance(form.RequestID, userID, form.ResponseText, form.NewStatusID); err != nil {
		return models.SendFailureResponse(c, models.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("回复援助，援助ID: %d", form.RequestID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ASSISTANCE)

	return models.SendSuccessResponse(c, nil)
}
