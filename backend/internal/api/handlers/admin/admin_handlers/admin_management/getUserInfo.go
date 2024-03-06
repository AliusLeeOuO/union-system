package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetUserInfoHandler(c *fiber.Ctx) error {
	var form dto.UserQueryRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	fieldsToCheck := map[string]interface{}{
		"user_id": form.UserID,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
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
