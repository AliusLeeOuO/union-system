package user_handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func ChangePasswordHandler(c *fiber.Ctx) error {
	// 获取请求数据
	var request dto.ChangePasswordRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证字段
	fieldsToCheck := map[string]string{
		"OldPassword": request.OldPassword,
		"NewPassword": request.NewPassword,
	}
	ok, missingField := check_fields.CheckFields(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("缺少必要字段: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID")
	if userID == nil {
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 初始化 service
	userRepo := repository.NewUserRepository(global.Database)
	userService := service.NewUserService(userRepo)

	err := userService.ChangeUserPassword(userID.(uint), request.OldPassword, request.NewPassword)
	if err != nil {
		return model.SendFailureResponse(c, model.SystemErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, nil)
}
