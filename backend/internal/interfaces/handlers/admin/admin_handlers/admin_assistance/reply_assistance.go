package admin_assistance

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
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
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.ReplyAssistance(form.RequestID, userID, form.ResponseText, form.NewStatusID); err != nil {
		return models.SendFailureResponse(c, models.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("回复援助，援助ID: %d", form.RequestID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ASSISTANCE)

	return models.SendSuccessResponse(c, nil)
}
