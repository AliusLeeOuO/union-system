package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func DeleteActivityHandler(c *fiber.Ctx) error {
	// 从 URL 路径参数中获取活动ID
	activityID := c.Params("activityId")
	activityIdInt, err := strconv.Atoi(activityID)
	if err != nil {
		// 处理错误：activityID 不是有效的整数
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "活动ID不是有效的整数")
	}

	// 初始化 service
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))

	// 删除活动
	err = activityService.DeleteActivity(uint(activityIdInt))
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, nil)
}
