package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetMyFeeStandard(c *fiber.Ctx) error {
	// 所有用户都是普通会员，且普通会员的CategoryID为1
	categoryID := uint(1)

	// 使用FeeService来获取会费标准
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeStandard, err := feeService.GetFeeStandardByCategory(categoryID)

	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "获取会费标准失败")
	}

	// 转换为DTO并返回
	return models.SendSuccessResponse(c, dto.FeeStandardResponse{
		SetStandard: err != nil,
		StandardID:  feeStandard.StandardID,
		CategoryID:  feeStandard.CategoryID,
		Amount:      feeStandard.Amount,
	})
}
