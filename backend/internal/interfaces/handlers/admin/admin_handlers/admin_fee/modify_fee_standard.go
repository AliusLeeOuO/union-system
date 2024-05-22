package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type ModifyFeeStandardRequest struct {
	Amount float64 `json:"amount" form:"amount" validate:"required"`
	Name   string  `json:"name" form:"name" validate:"required"`
}

func ModifyFeeStandard(c *fiber.Ctx) error {
	// 从动态路由中获取参数
	feeStandardID := c.Params("fee_standard_id")
	// 解析feeStandardID成uint
	feeStandardIDUint, err := strconv.ParseUint(feeStandardID, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "参数错误")
	}
	// 解析请求体
	var validate = validator.New()
	var request ModifyFeeStandardRequest
	if err = c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 调用service层方法
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err = feeService.ModifyFeeStandard(uint(feeStandardIDUint), request.Amount, request.Name)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
