package admin_activity

import (
	"fmt"
	"strconv"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

func DeleteActivityHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.DropActivityRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)

	// 从 URL 路径参数中获取活动ID
	activityID := c.Params("activityId")
	activityIdInt, err := strconv.Atoi(activityID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "活动ID不是有效的整数")
	}

	// 初始化 userService 并验证密码
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	isValidPassword, err := userService.VerifyPassword(userID, request.Password)
	if err != nil || !isValidPassword {
		return models.SendFailureResponse(c, models.LoginAuthErrorCode, "密码验证失败")
	}

	// 初始化 activityService
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))

	// 删除活动
	err = activityService.DeleteActivity(uint(activityIdInt))
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %v, 删除活动。", activityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
