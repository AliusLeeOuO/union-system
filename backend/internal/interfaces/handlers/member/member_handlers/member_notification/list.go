package member_notification

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetList(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	userID := c.Locals("userID").(uint)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	response, err := notificationService.GetNotificationsByRecipientID(userID, form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}

	return models.SendSuccessResponse(c, response)
}
