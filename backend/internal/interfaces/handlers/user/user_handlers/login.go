package user_handlers

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func LoginHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.LoginRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 初始化 service
	userService := service2.NewUserService(repository2.NewUserRepository(global.Database))
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	// 调用 service 登录方法
	userInfo, err := userService.Login(c, request.Username, request.Password, request.CaptchaID, request.CaptchaVal)
	if err != nil {
		_ = logService.AddLoginLog(c.Get("User-Agent"), c.IP(), false, request.Username)
		return models.SendFailureResponse(c, models.LoginAuthErrorCode, err.Error())
	}

	_ = logService.AddLoginLog(c.Get("User-Agent"), c.IP(), true, request.Username)

	return models.SendSuccessResponse(c, userInfo)
}
