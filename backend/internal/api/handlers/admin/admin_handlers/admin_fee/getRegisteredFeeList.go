package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

type Pagination struct {
	PageSize uint `form:"page_size" validate:"required"`
	PageNum  uint `form:"page_num" validate:"required"`
}

func GetRegisteredFeeList(c *fiber.Ctx) error {
	var validate = validator.New()
	var form Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeList, total, err := feeService.GetRegisteredFeeList(form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	res := &dto.UserWithFeeResponse{
		PageResponse: dto.PageResponse{
			Total:    total,
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
		},
		Users: feeList,
	}

	return model.SendSuccessResponse(c, res)
}
