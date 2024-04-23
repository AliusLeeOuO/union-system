package user_handlers

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func RegisterUserHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.UserRegisterRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 校验email
	if !check_fields.ValidateEmail(request.Email) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "邮箱格式错误")
	}
	// 校验手机号
	if !check_fields.ValidateMobile(request.PhoneNumber) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "手机号格式错误")
	}

	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	err := userService.RegisterUser(request.Username, request.Password, request.Email, strconv.Itoa(int(request.PhoneNumber)), request.InvitationCode)
	if err != nil {
		// 根据错误类型返回不同的HTTP状态码和消息
		return model.SendFailureResponse(c, fiber.StatusBadRequest, err.Error())
	}

	return model.SendSuccessResponse(c, "注册成功")
}
