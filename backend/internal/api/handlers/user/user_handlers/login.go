package user_handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/utils/captcha"
	"union-system/utils/jwt"
)

func LoginHandler(c *fiber.Ctx) error {
	var request dto.LoginRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证验证码
	if !captcha.VerifyCode(request.CaptchaID, request.CaptchaVal) {
		return model.SendFailureResponse(c, model.CaptchaErrorCode)
	}

	// 验证用户凭据
	user, isValid := repository.CheckCredentials(request.Username, request.Password)
	if !isValid {
		// 使用 BaseResponse 发送失败响应
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	var tokenStr, err = jwt.GenerateToken(jwt.UserInfo{
		Id:       user.ID,
		Username: user.Username,
	})

	if err != nil {
		// 生成 Token 出错
		return model.SendFailureResponse(c, model.SystemErrorCode)
	}

	// 保存 Token
	userTokenKey := fmt.Sprintf("user_tokens:%d", user.ID)

	// 使用 Redis 管道操作，添加新 Token，限制列表长度，设置过期时间
	pipe := global.RedisClient.Pipeline()
	pipe.LPush(c.Context(), userTokenKey, tokenStr)
	pipe.LTrim(c.Context(), userTokenKey, 0, 2) // 保持列表最多 3 个元素
	pipe.Expire(c.Context(), userTokenKey, 24*time.Hour)

	_, err = pipe.Exec(c.Context())
	if err != nil {
		return model.SendFailureResponse(c, model.SystemErrorCode)
	}

	// 返回 Token 以及用户的角色和状态
	responseData := map[string]interface{}{
		"userId":   user.ID,
		"username": user.Username,
		"role":     user.Role,
		"status":   user.Status,
		"token":    tokenStr,
	}

	// 使用 BaseResponse 发送成功响应
	return model.SendSuccessResponse(c, responseData)
}
