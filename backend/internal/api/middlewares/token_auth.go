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
		global.Logger.Info("Token 解析失败", err)
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 检查 Token 是否已过期
	if claims.ExpiresAt.Time.Before(time.Now()) {
		// 从 Redis 中删除过期 Token
		_, delErr := global.RedisClient.Del(c.Context(), tokenString).Result()
		if delErr != nil {
			global.Logger.Info("删除过期 Token 失败", delErr)
			//return model.SendFailureResponse(c, model.SystemErrorCode)
		}
		global.Logger.Info("Token 已过期")
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 检查 Redis 中是否存在这个 Token
	exists, err := global.RedisClient.Exists(c.Context(), tokenString).Result()
	if err != nil || exists == 0 {
		global.Logger.Info("Token 不存在")
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// Token 验证通过，可以设置用户信息到上下文
	c.Locals("userID", claims.User.Id)
	c.Locals("username", claims.User.Username)
	c.Locals("role", claims.User.Role)

	// 继续处理请求
	return c.Next()
}
