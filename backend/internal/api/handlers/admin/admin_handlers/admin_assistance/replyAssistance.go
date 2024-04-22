package admin_assistance

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

func ReplyAssistance(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.ReplyAssistanceRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)

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
