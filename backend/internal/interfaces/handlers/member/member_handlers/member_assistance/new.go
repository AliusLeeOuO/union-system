package member_assistance

import (
	"fmt"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

// NewAssistance 创建新的求助请求
func NewAssistance(c *fiber.Ctx) error {

	var validate = validator.New()
	var form dto.NewAssistanceRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 从 JWT 中获取 MemberID
	memberID := c.Locals("userID").(uint)

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))

	id, err := assistanceService.CreateNewAssistance(memberID, form)
	if err != nil {
		return models.SendFailureResponse(c, models.OperationFailedErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("创建了新的求助请求 %d", id)
	_ = logService.AddMemberLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ASSISTANCE)

	notificationService := service.NewNotificationService(repository.NewNotificationRepository(global.Database))
	_ = notificationService.InsertNotificationBySystem("创建新援助成功", "您已成功创建新援助", memberID)

	return models.SendSuccessResponse(c, fiber.Map{
		"request_id": id,
	})
}
