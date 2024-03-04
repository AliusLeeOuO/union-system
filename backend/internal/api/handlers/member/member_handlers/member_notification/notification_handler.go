package member_notification

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	notification := app.Group("/notification")

	notification.Post("/list", GetList)
	notification.Post("/read/:notificationId", ReadNotification)
}
