package member_notification

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetList(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	userID := c.Locals("userID").(uint)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	response, err := notificationService.GetNotificationsByRecipientID(userID, form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, response)
}
