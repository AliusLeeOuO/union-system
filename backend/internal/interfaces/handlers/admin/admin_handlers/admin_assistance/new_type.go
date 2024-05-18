package admin_assistance

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type NewAssistanceTypeRequest struct {
	Name string `json:"name" form:"name" validate:"required"`
}

func NewAssistanceType(c *fiber.Ctx) error {
	var validate = validator.New()
	var form NewAssistanceTypeRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.NewAssistanceType(form.Name); err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
