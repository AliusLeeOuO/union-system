package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetActivityDetails(c *fiber.Ctx) error {
	// 从 URL 路径参数中获取活动ID
	activityIDParam := c.Params("activityId")
	// 将 activityID 从字符串转换为 uint
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		// 如果转换失败，返回错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "Invalid activity ID")
	}

	// 初始化 service
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	// 调用 service 方法获取活动详情
	activityDetails, err := activityService.GetActivityDetails(uint(activityID))
	if err != nil {
		// 如果查询失败，返回错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "Failed to retrieve activity details")
	}

	// 成功获取活动详情，返回成功响应
	return model.SendSuccessResponse(c, activityDetails)
}
