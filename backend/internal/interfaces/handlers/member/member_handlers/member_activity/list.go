package member_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetActivitiesHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.ActivityListRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetAllActivities(c, form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	return models.SendSuccessResponse(c, dto.UserGetActivityListResponse{
		Data: activities,
		PageResponse: dto.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
	})
}
