package admin_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetFeeStandard(c *fiber.Ctx) error {
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeStandard, err := feeService.GetFeeStandardList()
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}
	// 如果feeStandard为空，返回空数组
	if len(feeStandard) == 0 {
		return models.SendSuccessResponse(c, []interface{}{})
	}
	return models.SendSuccessResponse(c, feeStandard)
}
