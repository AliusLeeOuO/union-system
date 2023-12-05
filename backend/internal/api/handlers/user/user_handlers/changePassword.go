package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
)

func ChangePasswordHandler(c *fiber.Ctx) error {
	// 获取请求数据
	var request dto.ChangePasswordRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID")
	if userID == nil {
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 验证旧密码
	if !repository.CheckUserPassword(userID.(uint), request.OldPassword) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "旧密码错误")
	}

	// 修改密码
	if err := repository.ChangePasswordByID(userID.(uint), request.NewPassword); err != nil {
		return model.SendFailureResponse(c, model.SystemErrorCode)
	}
	return model.SendSuccessResponse(c, nil)
}
