package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func CreateActivityHandler(c *fiber.Ctx) error {
	var req dto.CreateOrModifyActivityRequest
	if err := c.BodyParser(&req); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "无法解析请求")
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"Title":           req.Title,
		"Description":     req.Description,
		"StartTime":       req.StartTime,
		"EndTime":         req.EndTime,
		"Type":            req.Type,
		"Location":        req.Location,
		"MaxParticipants": req.MaxParticipants,
		"IsActive":        req.IsActive,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	// 从 JWT 中获取 userID
	userID := c.Locals("userID").(uint)
	// 检查时间（转换，使用time）
	startTime, err := time.Parse(time.RFC3339, req.StartTime)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, err.Error())
	}
	endTime, err := time.Parse(time.RFC3339, req.EndTime)
	if err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, err.Error())
	}
	if startTime.After(endTime) {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "开始时间不能晚于结束时间")
	}
	// 初始化 service 检查活动类型
	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activityType, err := activityService.GetActivityTypeById(req.Type)
	if err != nil || activityType.ActivityTypeId != req.Type {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "活动类型不存在")
	}
	id, err := activityService.CreateActivity(req, userID)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, dto.CreateActivityResponse{
		Success: true,
		Message: "活动创建成功",
		ID:      id,
	})
}
