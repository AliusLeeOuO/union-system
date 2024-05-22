package member_assistance

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/gofiber/fiber/v2"
)

func CloseAssistance(c *fiber.Ctx) error {
	var form dto.CloseAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 从 JWT 中获取用户ID
	userID := c.Locals("userID").(uint)

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.CloseAssistance(form, userID); err != nil {
		return models.SendFailureResponse(c, models.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("关闭了 %d 的请求", form.RequestID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ASSISTANCE)

	return models.SendSuccessResponse(c, nil)
}
