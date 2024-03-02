package member_fee

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	fee := app.Group("/fee")

	// 注册路由
	// 查看会费标准
	fee.Post("/standard", GetMyFeeStandard)
	// POST 查看会费记录
	fee.Post("/list", GetHistory)
	// POST 查询等待缴费项目
	fee.Post("/waiting", GetWaitingFee)
	// POST 缴纳会费
	fee.Post("/pay", PayForFee)
	// POST 申请会费减免
	fee.Post("/apply", ApplyFeeReduction)
}
