package admin_activity

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

func UnregisterUserRegister(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.UnregisterUserRegisterRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.UnregisterFromActivity(request.UserId, request.ActivityID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "不能取消活动报名")
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("取消用户注册，活动ID：%v,，用户ID：%v", request.ActivityID, request.UserId)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
