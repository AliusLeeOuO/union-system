package member_assistance

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

func UserReplyAssistance(c *fiber.Ctx) error {
	var form dto.UserReplyAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取用户ID
	userID := c.Locals("userID").(uint)

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.UserReplyAssistance(form, userID); err != nil {
		return model.SendFailureResponse(c, model.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("回复了 %d 的请求", form.RequestID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ASSISTANCE)

	return model.SendSuccessResponse(c, nil)
}
