package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetUserInfoHandler(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID")
	if userID == nil {
		return model.SendFailureResponse(c, model.AuthFailedCode)
	}

	// 初始化 repository service
	userService := service.NewUserService(repository.NewUserRepository(global.Database))

	// 查询用户信息
	user, err := userService.GetUserById(userID.(uint)) // 类型断言为 uint
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
