package admin_management

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/check_fields"
	"union-system/utils/log_model_enum"
)

func UpdateUserHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var updateReq dto.UpdateUserRequest
	if err := c.BodyParser(&updateReq); err != nil || validate.Struct(updateReq) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 校验email
	if !check_fields.ValidateEmail(updateReq.Email) {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "邮箱格式错误")
	}
	// 校验手机号
	phoneNum, parsePhoneError := strconv.Atoi(updateReq.Phone)
	if !check_fields.ValidateMobile(uint(phoneNum)) || parsePhoneError != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "手机号格式错误")
	}

	adminService := service2.NewAdminService(repository2.NewAdminRepository(global.Database))
	if err := adminService.UpdateUser(updateReq.UserId, updateReq); err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("修改用户信息: %v", updateReq.UserId)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.MANAGEMENT)

	return models.SendSuccessResponse(c, nil)
}
