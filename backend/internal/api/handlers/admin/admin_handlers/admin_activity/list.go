package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func ListActivitiesHandler(c *fiber.Ctx) error {
	var req dto.ActivityListRequest
	if err := c.BodyParser(&req); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": req.Pagination.PageSize,
		"PageNum":  req.Pagination.PageNum,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	response, err := activityService.ListActivities(req.Pagination)
	if err != nil {
		return model.SendFailureResponse(c, model.InvalidFileTypeErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, response)
}
