package admin_activity

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

func ModifyActivityLocation(c *fiber.Ctx) error {
	// 获取请求参数
	var request dto.ChangeActivityLocationRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"ActivityID": request.ActivityID,
		"Location":   request.Location,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("缺少必要字段: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	// 调用 service 层修改活动标题
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.ModifyActivityLocation(request.ActivityID, request.Location)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}
	return model.SendSuccessResponse(c, nil)
}
