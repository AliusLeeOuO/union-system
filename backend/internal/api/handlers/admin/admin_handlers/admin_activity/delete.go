package admin_activity

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

func DeleteActivityHandler(c *fiber.Ctx) error {
	var request dto.DropActivityRequest
	if err := c.BodyParser(&request); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "请求参数解析失败")
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"password": request.Password,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)

	// 从 URL 路径参数中获取活动ID
	activityID := c.Params("activityId")
	activityIdInt, err := strconv.Atoi(activityID)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "活动ID不是有效的整数")
	}

	// 初始化 userService 并验证密码
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	isValidPassword, err := userService.VerifyPassword(userID, request.Password)
	if err != nil || !isValidPassword {
		return model.SendFailureResponse(c, model.LoginAuthErrorCode, "密码验证失败")
	}

	// 初始化 activityService
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))

	// 删除活动
	err = activityService.DeleteActivity(uint(activityIdInt))
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %v, 删除活动。", activityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ACTIVITY)

	return model.SendSuccessResponse(c, nil)
}
