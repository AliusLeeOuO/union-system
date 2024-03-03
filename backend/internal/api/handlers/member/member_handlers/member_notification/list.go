package member_notification

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetList(c *fiber.Ctx) error {
	// 获取表单数据
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	userID := c.Locals("userID").(uint)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	response, err := notificationService.GetNotificationsByRecipientID(userID, form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, response)
}
