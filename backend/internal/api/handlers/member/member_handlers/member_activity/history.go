package member_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetRegisteredActivities(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.ActivityListRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	userID := c.Locals("userID").(uint)
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetRegisteredActivities(c, userID, form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, "Failed to retrieve registered activities")
	}

	// 将服务层返回的数据映射到 DTO
	response := dto.UserGetRegisteredActivityListResponse{
		Data: activities,
		PageResponse: dto.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
	}

	return model.SendSuccessResponse(c, response)
}
