package member_fee

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetWaitingFee(c *fiber.Ctx) error {
	// 从认证信息中获取用户ID，这里假设你已经有了一个中间件来设置用户ID
	userID := c.Locals("userID").(uint)

	// 从服务层获取等待缴费的账单信息
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database)) // 假设你已经实现了NewFeeService函数
	waitingBills, err := feeService.GetWaitingFeeBillsByUserID(int(userID))
	if err != nil {
		// 处理错误情况，返回错误响应
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "无法获取等待缴费项目",
		})
	}

	// 构造响应
	response := make([]dto.FeeBillResponse, 0, len(waitingBills))
	for _, bill := range waitingBills {
		response = append(response, dto.FeeBillResponse{
			BillID:        bill.BillID,
			UserID:        bill.UserID,
			Amount:        bill.Amount,
			DueDate:       bill.DueDate,
			FeePeriod:     bill.FeePeriod,
			FeeCategory:   bill.FeeCategory,
			PaymentStatus: bill.PaymentStatus,
			PaymentMethod: bill.PaymentMethod,
			CreatedAt:     bill.CreatedAt,
		})
	}

	// 返回成功响应
	return model.SendSuccessResponse(c, dto.WaitingFeeResponse{
		Bills: response,
	})
}
