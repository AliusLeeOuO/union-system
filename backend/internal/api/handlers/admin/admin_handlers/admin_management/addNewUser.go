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

func AddNewUser(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.CreateUserRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 校验email
	if !check_fields.ValidateEmail(request.Email) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "邮箱格式错误")
	}
	// 校验手机号
	if !check_fields.ValidateMobile(request.Phone) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "手机号格式错误")
	}
	// 将手机号转换成字符串
	phoneNumber := strconv.Itoa(int(request.Phone))
	// 初始化 service
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	// 创建用户
	err := userService.CreateUser(request.Username, request.Password, request.Email, request.Role, phoneNumber)
	if err != nil {
		return model.SendFailureResponse(c, model.SystemErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("新建用户")
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.MANAGEMENT)

	return model.SendSuccessResponse(c, nil)
}
