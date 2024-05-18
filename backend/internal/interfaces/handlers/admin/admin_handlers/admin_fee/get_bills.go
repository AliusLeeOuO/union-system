package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type GetBillsRequest struct {
	dto.Pagination
}

func GetBills(c *fiber.Ctx) error {
	var validate = validator.New()
	var request GetBillsRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	bills, total, err := feeService.GetBills(request.PageSize, request.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}
	if len(bills) == 0 {
		bills = make([]dto.FeeBillResponse, 0)
	}
	return models.SendSuccessResponse(c, dto.FeeHistoryResponse{
		PageResponse: dto.PageResponse{
			Total:    total,
			PageSize: request.PageSize,
			PageNum:  request.PageNum,
		},
		History: bills,
	})
}
