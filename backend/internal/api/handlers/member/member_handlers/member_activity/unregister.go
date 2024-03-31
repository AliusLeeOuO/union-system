package member_activity

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

func UnregisterFromActivity(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID
	activityIDParam := c.Params("activityId")
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "活动ID格式错误")
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err = activityService.UnregisterFromActivity(userID, uint(activityID))
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "不能取消活动报名")
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("用户取消了活动报名: %d", activityID)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ACTIVITY)

	return model.SendSuccessResponse(c, nil)
}
