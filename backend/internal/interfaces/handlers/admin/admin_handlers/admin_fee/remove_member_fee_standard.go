package admin_fee

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func RemoveMemberFeeStandard(c *fiber.Ctx) error {
	userId := c.Params("user_id")
	// 解析feeStandardID成uint
	userIdUint, err := strconv.ParseUint(userId, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "参数错误")
	}
	// 调用service层方法
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	err = feeService.RemoveMemberFeeStandard(uint(userIdUint))
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
