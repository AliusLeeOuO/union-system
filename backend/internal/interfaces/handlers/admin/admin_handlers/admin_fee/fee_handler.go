package admin_fee

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	fee := app.Group("/fee")

	fee.Post("/getRegisteredFeeList", GetRegisteredFeeList)
	fee.Post("/getNonRegisteredFeeList", GetNonRegisteredFeeList)
	fee.Get("/getFeeStandard", GetFeeStandard)
	fee.Put("/modifyFeeStandard/:fee_standard_id", ModifyFeeStandard)
	fee.Post("/addNewFeeStandard", AddNewFeeStandard)
	fee.Put("/changeFeeStandard/:user_id", ChangeFeeStandard)
	fee.Delete("/removeFeeStandard/:user_id", RemoveMemberFeeStandard)
	fee.Post("/getBills", GetBills)
}
