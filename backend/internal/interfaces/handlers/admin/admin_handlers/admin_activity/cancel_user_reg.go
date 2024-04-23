package admin_activity

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func UnregisterUserRegister(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.UnregisterUserRegisterRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	activityService := service2.NewActivityService(repository2.NewActivityRepository(global.Database))
	err := activityService.UnregisterFromActivity(request.UserId, request.ActivityID)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "不能取消活动报名")
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("取消用户注册，活动ID：%v,，用户ID：%v", request.ActivityID, request.UserId)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
