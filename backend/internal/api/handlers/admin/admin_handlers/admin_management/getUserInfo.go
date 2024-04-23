package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetUserInfoHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.UserQueryRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 初始化 repository service
	userService := service.NewUserService(repository.NewUserRepository(global.Database))

	// 查询用户信息
	user, err := userService.GetUserById(form.UserID) // 类型断言为 uint
	if err != nil {
		return model.SendFailureResponse(c, model.ResourceNotFoundCode)
	}

	// 准备返回的数据
	responseData := dto.UserInfoResponse{
		UserID:   user.UserID,
		Username: user.Username,
		Role:     user.UserTypeID,
		Email:    user.Email,
		Phone:    user.PhoneNumber,
		Status:   user.IsActive,
	}

	// 发送成功响应
	return model.SendSuccessResponse(c, responseData)
}
