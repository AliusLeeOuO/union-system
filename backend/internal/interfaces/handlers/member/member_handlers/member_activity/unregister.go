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

func UnregisterFromActivity(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID
	activityIDParam := c.Params("activityId")
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "活动ID格式错误")
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err = activityService.UnregisterFromActivity(userID, uint(activityID))
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "不能取消活动报名")
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("用户取消了活动报名: %d", activityID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
