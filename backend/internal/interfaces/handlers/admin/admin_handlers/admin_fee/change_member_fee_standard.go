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

type ChangeFeeStandardRequest struct {
	NewStandardId uint `json:"new_standard_id" form:"new_standard_id" validate:"required"`
}

func ChangeFeeStandard(c *fiber.Ctx) error {
	userId := c.Params("user_id")
	// 解析feeStandardID成uint
	userIdUint, err := strconv.ParseUint(userId, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "参数错误")
	}
	// 解析请求体
	var validate = validator.New()
	var request ChangeFeeStandardRequest
	if err = c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 调用service层方法
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err = feeService.ChangeFeeStandard(uint(userIdUint), request.NewStandardId)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
