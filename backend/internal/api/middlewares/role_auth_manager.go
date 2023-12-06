package middlewares

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/model"
)

func RoleAuthAdmin(c *fiber.Ctx) error {
	// 读取用户信息
	userID := c.Locals("userID")
	username := c.Locals("username")
	role := c.Locals("role")

	// 检查是否获取到了用户信息
	if userID == nil || username == nil || role == nil {
		// 未获取到用户信息的处理逻辑...
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}
	// 检查用户角色
	if role.(uint) != 2 {
		// 用户角色不匹配的处理逻辑...
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 使用用户信息继续处理请求...
	return c.Next()
}
