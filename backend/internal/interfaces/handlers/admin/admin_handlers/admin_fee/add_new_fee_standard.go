package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type AdminNewFeeStandardRequest struct {
	Amount float64 `json:"amount" form:"amount" validate:"required"`
	Name   string  `json:"name" form:"name" validate:"required"`
}

func AddNewFeeStandard(c *fiber.Ctx) error {
	// 解析请求体
	var validate = validator.New()
	var request AdminNewFeeStandardRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 调用service层方法
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err := feeService.AddFeeStandard(request.Amount, request.Name)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	return models.SendSuccessResponse(c, nil)
}
