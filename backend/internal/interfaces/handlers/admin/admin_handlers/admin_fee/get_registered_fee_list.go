package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type Pagination struct {
	PageSize uint `form:"page_size" validate:"required"`
	PageNum  uint `form:"page_num" validate:"required"`
}

func GetRegisteredFeeList(c *fiber.Ctx) error {
	var validate = validator.New()
	var form Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeList, total, err := feeService.GetRegisteredFeeList(form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	res := &dto2.UserWithFeeResponse{
		PageResponse: dto2.PageResponse{
			Total:    total,
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
		},
		Users: feeList,
	}

	return models.SendSuccessResponse(c, res)
}
