package member_assistance

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func NewAssistance(c *fiber.Ctx) error {
	var form dto.NewAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	fmt.Println("form:", form)

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"Title":       form.Title,
		"Description": form.Description,
		"TypeID":      int(form.TypeID),
	}
	fmt.Println("fieldsCheck:", fieldsToCheck)
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 从 JWT 中获取 MemberID
	memberID := c.Locals("userID").(uint)

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	if err := assistanceService.CreateNewAssistance(memberID, form); err != nil {
		return model.SendFailureResponse(c, model.OperationFailedErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, fiber.Map{
		"success": true,
		"message": "Assistance request created successfully",
	})
}
