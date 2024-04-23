package middlewares

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/interfaces/models"
	"union-system/utils/jwt"
)

func TokenAuth(c *fiber.Ctx) error {
	// 从请求中获取 Token
	authorizationString := c.Get("Authorization")

	// 如果请求头中没有 Token，尝试从请求参数中获取
	if authorizationString == "" {
		authorizationString = c.Query("AuthorizationQuery")
	}
	// 如果 Token 不存在，返回错误
	if authorizationString == "" {
		global.Logger.Info("Token 不存在")
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}
	// 检查 Token 是否以 Bearer 开头
	if len(authorizationString) < 7 || authorizationString[:7] != "Bearer " {
		global.Logger.Info("Token 不存在2")
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}
	// 获取 Token
	tokenString := authorizationString[7:]
	// 解析 Token
	claims, err := jwt.ParseToken(tokenString)
	if err != nil {
		global.Logger.Info("Token 解析失败", err)
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}

	// 检查 Token 是否已过期
	if claims.ExpiresAt.Time.Before(time.Now()) {
		// 从 Redis 中删除过期 Token
		_, delErr := global.RedisClient.Del(c.Context(), tokenString).Result()
		if delErr != nil {
			global.Logger.Info("删除过期 Token 失败", delErr)
		}
		global.Logger.Info("Token 已过期")
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}

	// 检查 Redis 中是否存在这个 Token，从user_tokens:userID中获取
	// 构建用户的 Token 列表的 key
	userTokenKey := fmt.Sprintf("user_tokens:%d", claims.User.Id)

	// 获取用户的 Token 列表
	tokens, err := global.RedisClient.LRange(c.Context(), userTokenKey, 0, -1).Result()
	if err != nil {
		//return false, err
	}

	var haveToken bool = false
	// 检查 Token 是否在列表中
	for _, token := range tokens {
		if token == tokenString {
			// Token 存在，验证通过
			haveToken = true
			break
		}
	}

	if !haveToken {
		global.Logger.Info("Token 已被注销")
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}

	// Token 验证通过，可以设置用户信息到上下文
	c.Locals("userID", claims.User.Id)
	c.Locals("username", claims.User.Username)
	c.Locals("role", claims.User.Role)

	// 继续处理请求
	return c.Next()
}
