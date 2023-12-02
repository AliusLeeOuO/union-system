package middlewares

import (
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/model"
	"union-system/utils/jwt"
)

func TokenAuth(c *fiber.Ctx) error {
	// 从请求中获取 Token
	tokenString := c.Get("Authorization")

	// 解析 Token
	claims, err := jwt.ParseToken(tokenString)
	if err != nil {
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 检查 Token 是否已过期
	if claims.ExpiresAt.Time.Before(time.Now()) {
		// 从 Redis 中删除过期 Token
		_, delErr := global.RedisClient.Del(c.Context(), tokenString).Result()
		if delErr != nil {
			return model.SendFailureResponse(c, model.SystemErrorCode)
		}

		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 检查 Redis 中是否存在这个 Token
	exists, err := global.RedisClient.Exists(c.Context(), tokenString).Result()
	if err != nil || exists == 0 {
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// Token 验证通过，可以设置用户信息到上下文
	c.Locals("userID", claims.User.Id)
	c.Locals("username", claims.User.Username)

	// 继续处理请求
	return c.Next()
}
