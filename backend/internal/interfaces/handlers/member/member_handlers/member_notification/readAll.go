package member_notification

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func MarkAllNotificationsRead(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)

	// 初始化Service
	notificationService := service2.NewNotificationService(repository2.NewNotificationRepository(global.Database))

	// 调用服务层方法将所有通知标记为已读
	err := notificationService.MarkAllAsRead(userID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("标记了所有通知为已读")
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.NOTIFICATION)

	return models.SendSuccessResponse(c, nil)
}
