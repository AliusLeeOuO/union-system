package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetMyFeeStandard(c *fiber.Ctx) error {
	// 所有用户都是普通会员，且普通会员的CategoryID为1
	categoryID := uint(1)

	// 使用FeeService来获取会费标准
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeStandard, err := feeService.GetFeeStandardByCategory(categoryID)

	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "获取会费标准失败")
	}

	// 转换为DTO并返回
	return model.SendSuccessResponse(c, dto.FeeStandardResponse{
		SetStandard: err != nil,
		StandardID:  feeStandard.StandardID,
		CategoryID:  feeStandard.CategoryID,
		Amount:      feeStandard.Amount,
	})
}
