package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetMyFeeStandard(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)
	// 使用FeeService来获取会费标准
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeStandard, err := feeService.CheckFeeStandard(userID)

	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "获取会费标准失败")
	}

	// 转换为DTO并返回
	return models.SendSuccessResponse(c, feeStandard)
}
