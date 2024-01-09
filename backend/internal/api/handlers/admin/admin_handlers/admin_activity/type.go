package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetActivityType(c *fiber.Ctx) error {
	var request []dto.GetActivityTypeRequest

	// 初始化 service
	activityTypeService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	// 调用 service 获取数据
	request, err := activityTypeService.GetActivityType()
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	return model.SendSuccessResponse(c, request)
}
