package admin_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func ListActivitiesHandler(c *fiber.Ctx) error {
	// 获取表单数据
	var validate = validator.New()
	var from dto.ActivityListRequest
	if err := c.BodyParser(&from); err != nil || validate.Struct(from) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetAllActivities(c, from.PageSize, from.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, dto.UserGetActivityListResponse{
		Data: activities,
		PageResponse: dto.PageResponse{
			PageSize: from.PageSize,
			PageNum:  from.PageNum,
			Total:    total,
		},
	})
}
