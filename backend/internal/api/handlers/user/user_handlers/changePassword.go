package user_handlers

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func ChangePasswordHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.ChangePasswordRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
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
