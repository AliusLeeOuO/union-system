package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func CheckFeeStatus(c *fiber.Ctx) error {
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	status, err := feeService.CheckFeeStatus(userID)
	if err != nil {
		return err
	}
	return models.SendSuccessResponse(c, status)
}
