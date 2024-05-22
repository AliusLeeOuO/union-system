package member_activity

import (
	"fmt"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/gofiber/fiber/v2"
)

func RegisterForActivity(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID
	activityIDParam := c.Params("activityId")
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "错误的活动ID")
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err = activityService.RegisterForActivity(userID, uint(activityID))
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "已经报名过该活动了")
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("用户报名了活动: %d", activityID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	_ = notificationService.InsertNotificationBySystem("报名成功", "您已成功报名活动", userID)

	return models.SendSuccessResponse(c, nil)
}
