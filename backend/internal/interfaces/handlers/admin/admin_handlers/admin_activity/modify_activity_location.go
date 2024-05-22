package admin_activity

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

func ModifyActivityLocation(c *fiber.Ctx) error {
	// 获取请求参数
	var validate = validator.New()
	var request dto.ChangeActivityLocationRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 调用 service 层修改活动地址
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	err := activityService.ModifyActivityLocation(request.ActivityID, request.Location)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %d, 修改新地址", request.ActivityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
