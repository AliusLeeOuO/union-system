package member_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetRegisteredActivities(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto2.ActivityListRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	userID := c.Locals("userID").(uint)
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetRegisteredActivities(c, userID, form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, "Failed to retrieve registered activities")
	}

	// 将服务层返回的数据映射到 DTO
	response := dto2.UserGetRegisteredActivityListResponse{
		Data: activities,
		PageResponse: dto2.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
	}

	return models.SendSuccessResponse(c, response)
}
