package user_handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func LoginHandler(c *fiber.Ctx) error {
	var request dto.LoginRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"Username":   request.Username,
		"Password":   request.Password,
		"CaptchaID":  request.CaptchaID,
		"CaptchaVal": request.CaptchaVal,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("缺少必要字段: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 初始化 service
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	// 调用 service 登录方法
	userInfo, err := userService.Login(request.Username, request.Password, request.CaptchaID, request.CaptchaVal)
	if err != nil {
		_ = logService.AddLoginLog(c.Get("User-Agent"), c.IP(), false, request.Username)
		return model.SendFailureResponse(c, model.LoginAuthErrorCode, err.Error())
	}

	// 保存 Token 到 Redis
	userTokenKey := fmt.Sprintf("user_tokens:%d", userInfo.UserId)
	// 使用 Redis 管道操作，添加新 Token，限制列表长度，设置过期时间
	pipe := global.RedisClient.Pipeline()
	pipe.LPush(c.Context(), userTokenKey, userInfo.Token)
	pipe.LTrim(c.Context(), userTokenKey, 0, 2) // 保持列表最多 3 个元素
	pipe.Expire(c.Context(), userTokenKey, 24*time.Hour)

	_, err = pipe.Exec(c.Context())
	if err != nil {
		global.Logger.Info("保存 Token 出错", err)
		return model.SendFailureResponse(c, model.SystemErrorCode, "保存 Token 出错")
	}

	_ = logService.AddLoginLog(c.Get("User-Agent"), c.IP(), true, request.Username)

	return model.SendSuccessResponse(c, userInfo)
}
