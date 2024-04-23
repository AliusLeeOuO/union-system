package admin_management

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
	"union-system/utils/logModelEnum"
)

func UpdateUserHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var updateReq dto.UpdateUserRequest
	if err := c.BodyParser(&updateReq); err != nil || validate.Struct(updateReq) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 校验email
	if !check_fields.ValidateEmail(updateReq.Email) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "邮箱格式错误")
	}
	// 校验手机号
	phoneNum, parsePhoneError := strconv.Atoi(updateReq.Phone)
	if !check_fields.ValidateMobile(uint(phoneNum)) || parsePhoneError != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "手机号格式错误")
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	if err := adminService.UpdateUser(updateReq.UserId, updateReq); err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("修改用户信息: %v", updateReq.UserId)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.MANAGEMENT)

	return model.SendSuccessResponse(c, nil)
}
