package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetActivityDetails(c *fiber.Ctx) error {
	// 从认证中间件获取 userID
	userID := c.Locals("userID").(uint)
	// 从 URL 路径参数中获取活动ID
	activityIDParam := c.Params("activityId")
	// 将 activityID 从字符串转换为 uint
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		// 如果转换失败，返回错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "错误的活动ID")
	}

	// 初始化 service
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	// 调用 service 方法获取活动详情
	activityDetails, err := activityService.GetActivityDetails(c, uint(activityID))
	if err != nil {
		// 如果查询失败，返回错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "获取活动详情失败")
	}
	// 用户报名活动信息
	isRegistered := activityService.GetUserActivityRegistrationStatus(userID, uint(activityID))

	response := dto.ActivityDetailResponse{
		ActivityResponse: activityDetails,
		IsRegistered:     isRegistered,
	}

	// 成功获取活动详情，返回成功响应
	return model.SendSuccessResponse(c, response)
}
