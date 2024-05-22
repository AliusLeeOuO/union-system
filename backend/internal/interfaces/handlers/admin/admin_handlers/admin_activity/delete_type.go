package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func DeleteType(c *fiber.Ctx) error {
	// 从 URL 路径参数中获取ID
	activityID := c.Params("typeId")
	// 转换为 uint 类型
	activityIDConverter, err := strconv.ParseUint(activityID, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	activityIDUint := uint(activityIDConverter)
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err = activityService.DeleteActivityType(activityIDUint)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
