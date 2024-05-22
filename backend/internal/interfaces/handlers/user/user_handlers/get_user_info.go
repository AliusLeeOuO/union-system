package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetUserInfoHandler(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID")
	if userID == nil {
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}

	// 初始化 repository service
	userService := service.NewUserService(repository.NewUserRepository(global.Database))

	// 查询用户信息
	user, err := userService.GetUserById(userID.(uint)) // 类型断言为 uint
	if err != nil {
		return models.SendFailureResponse(c, models.ResourceNotFoundCode)
	}

	// 准备返回的数据
	responseData := dto.UserInfoResponse{
		UserID:      user.UserID,
		Username:    user.Username,
		Role:        user.UserTypeID,
		Email:       user.Email,
		Phone:       user.PhoneNumber,
		Status:      user.IsActive,
		AccountType: user.UserRole,
	}

	// 发送成功响应
	return models.SendSuccessResponse(c, responseData)
}
