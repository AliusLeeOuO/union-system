package member_activity

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func RegisterForActivity(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID
	activityIDParam := c.Params("activityId")
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "错误的活动ID")
	}

	activityService := service2.NewActivityService(repository2.NewActivityRepository(global.Database))
	err = activityService.RegisterForActivity(userID, uint(activityID))
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "已经报名过该活动了")
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("用户报名了活动: %d", activityID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
