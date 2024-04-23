package member_notification

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func ReadNotification(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)
	// 从 URL 路径参数中获取通知ID
	notificationIdParam := c.Params("notificationId")
	// 将 notificationIdParam 从字符串转换为 uint
	notificationId, err := strconv.ParseUint(notificationIdParam, 10, 32)

	// 初始化Service
	notificationService := service2.NewNotificationService(repository2.NewNotificationRepository(global.Database))
	// 调用服务层方法标记通知为已读
	err = notificationService.MarkAsRead(uint(notificationId), userID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("标记了通知为已读: %d", notificationId)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.NOTIFICATION)

	return models.SendSuccessResponse(c, nil)
}
