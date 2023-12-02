package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/model"
	"union-system/utils/captcha"
)

func GetCaptchaHandler(c *fiber.Ctx) error {
	captchaResp, err := captcha.CreateCaptcha()
	if err != nil {
		global.Logger.Info("生成验证码失败", err)
		// 处理错误情况
		return model.SendFailureResponse(c, fiber.StatusInternalServerError)
	}

	// 发送成功响应，包含验证码信息
	global.Logger.Info("生成验证码成功")
	return model.SendSuccessResponse(c, captchaResp)
}
