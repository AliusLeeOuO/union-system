package admin_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func ModifyActivityHandler(c *fiber.Ctx) error {
	var req dto.CreateOrModifyActivityRequest
	if err := c.BodyParser(&req); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "无法解析请求")
	}
	// 获取活动ID
	activityID := c.Params("activityId")
	activityIdInt, err := strconv.Atoi(activityID)
	if err != nil {
		// 处理错误：activityID 不是有效的整数
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid activity ID"})
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
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
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
	// 修改活动
	id, err := activityService.EditActivity(uint(activityIdInt), req)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	return model.SendSuccessResponse(c, dto.CreateActivityResponse{
		Success: true,
		Message: "活动修改成功",
		ID:      id,
	})
}
