package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetActivitiesHandler(c *fiber.Ctx) error {
	// 获取表单数据
	var from dto.ActivityListRequest
	if err := c.BodyParser(&from); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(from.PageSize),
		"PageNum":  int(from.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetAllActivities(from.PageSize, from.PageNum)
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
