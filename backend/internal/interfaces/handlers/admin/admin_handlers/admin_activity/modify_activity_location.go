package admin_activity

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func ModifyActivityLocation(c *fiber.Ctx) error {
	// 获取请求参数
	var validate = validator.New()
	var request dto.ChangeActivityLocationRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 调用 service 层修改活动地址
	activityService := service2.NewActivityService(repository2.NewActivityRepository(global.Database))
	err := activityService.ModifyActivityLocation(request.ActivityID, request.Location)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %d, 修改新地址", request.ActivityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, nil)
}
