package user_handlers

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func ChangePasswordHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.ChangePasswordRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 从 JWT 中获取 userID
	userID := c.Locals("userID")
	if userID == nil {
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}

	// 初始化 service
	userRepo := repository.NewUserRepository(global.Database)
	userService := service.NewUserService(userRepo)

	err := userService.ChangeUserPassword(userID.(uint), request.OldPassword, request.NewPassword)
	if err != nil {
		return models.SendFailureResponse(c, models.SystemErrorCode, err.Error())
	}

	return models.SendSuccessResponse(c, nil)
}
