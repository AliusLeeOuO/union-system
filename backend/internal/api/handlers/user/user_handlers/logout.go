package user_handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/model"
)

func LogoutHandler(c *fiber.Ctx) error {
	// 从请求中获取 Token
	tokenString := c.Get("Authorization")[7:]

	// 获取用户 ID（假设已通过之前的认证中间件设置）
	userID := c.Locals("userID").(uint)

	// 构建用户的 Token 列表的 key
	userTokenKey := fmt.Sprintf("user_tokens:%d", userID)

	// 使用 Redis 管道操作执行删除
	pipe := global.RedisClient.Pipeline()
	pipe.Del(c.Context(), tokenString)                   // 删除 Token
	pipe.LRem(c.Context(), userTokenKey, 0, tokenString) // 从用户 Token 列表中移除
	_, err := pipe.Exec(c.Context())
	if err != nil {
		//return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to logout"})
		return model.SendFailureResponse(c, model.SystemErrorCode)
	}

	return model.SendSuccessResponse(c, nil)
}
