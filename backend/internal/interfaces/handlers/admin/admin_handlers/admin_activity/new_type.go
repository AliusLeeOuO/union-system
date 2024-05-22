package admin_activity

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type NewTypeRequest struct {
	Name string `json:"name" form:"name" validate:"required"`
}

func NewType(c *fiber.Ctx) error {
	var validate = validator.New()
	var req NewTypeRequest
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	_, err := activityService.CreateActivityType(req.Name)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
