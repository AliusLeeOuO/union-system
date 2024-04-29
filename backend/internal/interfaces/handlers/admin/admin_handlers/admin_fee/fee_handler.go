package admin_fee

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	fee := app.Group("/fee")

	fee.Post("/getRegisteredFeeList", GetRegisteredFeeList)
	fee.Post("/getNonRegisteredFeeList", GetNonRegisteredFeeList)
}
