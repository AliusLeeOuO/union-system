package user_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
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
	userRepo := repository.NewUserRepository(global.Database)
	userService := service.NewUserService(userRepo)

	// 查询用户信息
	user, err := userService.GetUserById(userID.(uint)) // 类型断言为 uint
	if err != nil {
		return model.SendFailureResponse(c, model.ResourceNotFoundCode)
	}

	// 准备返回的数据
	responseData := map[string]interface{}{
		"userID":   user.ID,
		"username": user.Username,
		"role":     user.Role,
		"status":   user.Status,
	}

	// 发送成功响应
	return model.SendSuccessResponse(c, responseData)
}
