package admin_management

import (
	"fmt"
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
	// 获取请求数据
	var request dto.CreateUserRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 校验表单
	fieldsToCheck := map[string]interface{}{
		"username": request.Username,
		"password": request.Password,
		"role":     request.Role,
		"email":    request.Email,
		"phone":    request.Phone,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
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
