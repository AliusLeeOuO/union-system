package admin_management

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

func GenerateInvitationCodeHandler(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)

	// 生成邀请码
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	invitationCode, err := userService.GenerateInvitationCode(userID)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("生成新邀请码: %v", invitationCode.Code)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.MANAGEMENT)

	// 返回生成的邀请码
	return model.SendSuccessResponse(c, invitationCode)
}
