package member_notification

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetUnreadNotificationsCount(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)

	// 初始化Service
	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))

	// 调用服务层方法获取未读通知数量
	count, err := notificationService.GetUnreadNotificationCount(userID)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "获取未读通知数量失败")
	}

	return model.SendSuccessResponse(c, count)
}
