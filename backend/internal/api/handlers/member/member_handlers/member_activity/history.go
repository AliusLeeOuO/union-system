package member_activity

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetRegisteredActivities(c *fiber.Ctx) error {
	userID := c.Locals("userID").(uint) // 从认证中间件获取 userID

	// 获取表单数据
	var form dto.ActivityListRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "Failed to parse request body")
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("Missing required fields: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetRegisteredActivities(userID, form.PageSize, form.PageNum)
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

	return c.JSON(response)
}
