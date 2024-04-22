package admin_activity

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

func UnregisterUserRegister(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.UnregisterUserRegisterRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.UnregisterFromActivity(request.UserId, request.ActivityID)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "不能取消活动报名")
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("取消用户注册，活动ID：%v,，用户ID：%v", request.ActivityID, request.UserId)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ACTIVITY)

	return model.SendSuccessResponse(c, nil)
}
