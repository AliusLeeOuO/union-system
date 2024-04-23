package member_assistance

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/logModelEnum"
)

// NewAssistance 创建新的求助请求
func NewAssistance(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.NewAssistanceRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 从 JWT 中获取 MemberID
	memberID := c.Locals("userID").(uint)

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))

	id, err := assistanceService.CreateNewAssistance(memberID, form)
	if err != nil {
		return model.SendFailureResponse(c, model.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("创建了新的求助请求 %d", id)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, logModelEnum.ASSISTANCE)

	return model.SendSuccessResponse(c, fiber.Map{
		"request_id": id,
	})
}
