package member_notification

import (
	"github.com/gofiber/fiber/v2"
)

func ReadNotification(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)
	// 从 URL 路径参数中获取通知ID
	notificationIdParam := c.Params("notificationId")
	// 将 notificationIdParam 从字符串转换为 uint
	notificationId, err := strconv.ParseUint(notificationIdParam, 10, 32)

	// 初始化Service
	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	// TODO service没写
	return nil
}