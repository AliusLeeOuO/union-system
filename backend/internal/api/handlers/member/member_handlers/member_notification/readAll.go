package member_notification

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func MarkAllNotificationsRead(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)

	// 初始化Service
	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))

	// 调用服务层方法将所有通知标记为已读
	err := notificationService.MarkAllAsRead(userID)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, nil)
}
