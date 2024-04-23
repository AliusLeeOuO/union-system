package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetActivityDetails(c *fiber.Ctx) error {
	// 从 URL 路径参数中获取活动ID
	activityIDParam := c.Params("activityId")
	// 将 activityID 从字符串转换为 uint
	activityID, err := strconv.ParseUint(activityIDParam, 10, 32)
	if err != nil {
		// 如果转换失败，返回错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "错误的活动ID")
	}

	// 初始化 service
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	// 调用 service 方法获取活动详情
	activityDetails, err := activityService.GetActivityDetails(c, uint(activityID))
	if err != nil {
		// 如果查询失败，返回错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "获取活动详情失败")
	}

	if activityDetails.RegistrationCount == 0 {
		response := dto.ActivityDetailManagementResponse{
			ActivityResponse: activityDetails,
			Registrations:    nil,
		}
		return models.SendSuccessResponse(c, response)
	}

	registrations, err := activityService.GetActivityUserRegistrations(uint(activityID))
	if err != nil {
		return err
	}

	response := dto.ActivityDetailManagementResponse{
		ActivityResponse: activityDetails,
		Registrations:    registrations,
	}

	// 成功获取活动详情，返回成功响应
	return models.SendSuccessResponse(c, response)
}
