package admin_activity

import (
	"fmt"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

func CreateActivityHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var req dto.CreateOrModifyActivityRequest
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)
	// 检查时间（转换，使用time）
	startTime, err := time.Parse(time.RFC3339, req.StartTime)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	endTime, err := time.Parse(time.RFC3339, req.EndTime)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	if startTime.After(endTime) {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "开始时间不能晚于结束时间")
	}
	// 初始化 service 检查活动类型
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activityType, err := activityService.GetActivityTypeById(c, req.Type)
	if err != nil || activityType.ActivityTypeId != req.Type {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "活动类型不存在")
	}
	id, err := activityService.CreateActivity(req, userID)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service.NewLogService(repository.NewLogRepository(global.Database))
	logString := fmt.Sprintf("创建新活动，活动ID：%v", id)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, dto.CreateActivityResponse{
		Success: true,
		Message: "活动创建成功",
		ID:      id,
	})
}
