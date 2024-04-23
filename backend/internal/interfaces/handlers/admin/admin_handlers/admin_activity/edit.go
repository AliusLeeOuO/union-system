package admin_activity

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"strconv"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	service2 "union-system/internal/application/service"
	repository2 "union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/log_model_enum"
)

func ModifyActivityHandler(c *fiber.Ctx) error {
	var validate = validator.New()
	var req dto.CreateOrModifyActivityRequest
	if err := c.BodyParser(&req); err != nil || validate.Struct(req) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
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
	activityService := service2.NewActivityService(repository2.NewActivityRepository(global.Database))
	activityType, err := activityService.GetActivityTypeById(c, req.Type)
	if err != nil || activityType.ActivityTypeId != req.Type {
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "活动类型不存在")
	}

	// 获取活动ID
	activityID := c.Params("activityId")
	activityIdInt, err := strconv.Atoi(activityID)
	if err != nil {
		// 处理错误：activityID 不是有效的整数
		return models.SendFailureResponse(c, models.QueryParamErrorCode, "无效的活动ID")
	}

	// 修改活动
	id, err := activityService.EditActivity(uint(activityIdInt), req)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	// 记录日志
	logService := service2.NewLogService(repository2.NewLogRepository(global.Database))
	logString := fmt.Sprintf("活动ID: %v, 修改活动。", activityID)
	_ = logService.AddAdminLog(c.Locals("userID").(uint), c.IP(), logString, log_model_enum.ACTIVITY)

	return models.SendSuccessResponse(c, dto.CreateActivityResponse{
		Success: true,
		Message: "活动修改成功",
		ID:      id,
	})
}
