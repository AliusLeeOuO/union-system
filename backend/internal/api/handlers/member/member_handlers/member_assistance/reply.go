package member_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
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

	return model.SendSuccessResponse(c, fiber.Map{
		"success": true,
		"message": "Reply submitted successfully, and assistance request status updated.",
	})
}
