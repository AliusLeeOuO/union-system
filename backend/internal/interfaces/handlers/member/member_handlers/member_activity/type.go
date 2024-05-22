package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetActivityType(c *fiber.Ctx) error {
	var request []dto.GetActivityTypeRequest

	// 初始化 service
	activityTypeService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	// 调用 service 获取数据
	request, err := activityTypeService.GetActivityType()
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	return models.SendSuccessResponse(c, request)
}
