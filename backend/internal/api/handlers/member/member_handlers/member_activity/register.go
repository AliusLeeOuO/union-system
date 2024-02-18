package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func RegisterForActivity(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID
	activityIDParam := c.Params("activityId")
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "错误的活动ID")
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err = activityService.RegisterForActivity(userID, uint(activityID))
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "已经报名过该活动了")
	}

	return model.SendSuccessResponse(c, nil)
}
