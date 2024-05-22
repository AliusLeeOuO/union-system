package admin_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func ListActivitiesHandler(c *fiber.Ctx) error {
	// 获取表单数据
	var validate = validator.New()
	var from dto.ActivityListRequest
	if err := c.BodyParser(&from); err != nil || validate.Struct(from) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetAllActivities(c, from.PageSize, from.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	return models.SendSuccessResponse(c, dto.UserGetActivityListResponse{
		Data: activities,
		PageResponse: dto.PageResponse{
			PageSize: from.PageSize,
			PageNum:  from.PageNum,
			Total:    total,
		},
	})
}
