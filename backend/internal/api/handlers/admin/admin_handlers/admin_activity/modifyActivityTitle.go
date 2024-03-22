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
	"union-system/utils/logModelEnum"
)

// ModifyActivityTitle 修改活动标题
func ModifyActivityTitle(c *fiber.Ctx) error {
	// 获取请求参数
	var request dto.ChangeActivityTitleRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"ActivityID": request.ActivityID,
		"NewTitle":   request.Title,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("缺少必要字段: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	// 调用 service 层修改活动标题
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.ModifyActivityTitle(request.ActivityID, request.Title)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %d, 修改新标题。", request.ActivityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ACTIVITY)

	return model.SendSuccessResponse(c, nil)
}
