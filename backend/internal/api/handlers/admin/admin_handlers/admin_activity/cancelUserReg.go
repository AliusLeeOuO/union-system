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

func UnregisterUserRegister(c *fiber.Ctx) error {
	var request dto.UnregisterUserRegisterRequest
	if err := c.BodyParser(&request); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "请求参数错误")
	}
	// 校验字段
	fieldsToCheck := map[string]interface{}{
		"activityId": request.ActivityID,
		"userId":     request.UserId,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.UnregisterFromActivity(request.UserId, request.ActivityID)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "不能取消活动报名")
	}

	return model.SendSuccessResponse(c, nil)
}
