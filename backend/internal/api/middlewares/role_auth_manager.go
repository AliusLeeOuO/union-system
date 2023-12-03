package middlewares

import "github.com/gofiber/fiber/v2"

func RoleAuthManager(c *fiber.Ctx) error {
	// 读取用户信息
	userID := c.Locals("userID")
	username := c.Locals("username")
	role := c.Locals("role")

	// 检查是否获取到了用户信息
	if userID == nil || username == nil || role == nil {
		// 未获取到用户信息的处理逻辑...
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
	}

	// 使用用户信息继续处理请求...
	return c.Next()
}
