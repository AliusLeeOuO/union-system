package admin_management

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/gofiber/fiber/v2"
)

func GenerateInvitationCodeHandler(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)

	// 生成邀请码
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	invitationCode, err := userService.GenerateInvitationCode(userID)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("生成新邀请码: %v", invitationCode.Code)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.MANAGEMENT)

	// 返回生成的邀请码
	return models.SendSuccessResponse(c, invitationCode)
}
