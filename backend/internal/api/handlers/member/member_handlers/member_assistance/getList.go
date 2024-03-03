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

func GetMyAssistances(c *fiber.Ctx) error {
	memberID := c.Locals("userID").(uint) // 用户ID已经通过认证中间件设置

	// 获取表单数据
	var form dto.ActivityListRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "无法解析请求")
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := fmt.Sprintf("Missing required fields: %s", missingField)
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	assistances, total, resolvedCount, pendingReviewCount, err := assistanceService.GetMyAssistances(memberID, form.PageSize, form.PageNum)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, "无法获取工单列表")
	}

	// 获取status类型
	assistanceStatus, err := assistanceService.GetAssistanceStatus(c)
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, "无法获取工单状态")
	}
	// 整理成dto
	assistanceStatusDTO := make([]dto.AssistanceStatusDTO, 0)
	for _, status := range assistanceStatus {
		assistanceStatusDTO = append(assistanceStatusDTO, dto.AssistanceStatusDTO{
			StatusID:   status.ID,
			StatusName: status.Name,
		})
	}

	return model.SendSuccessResponse(c, dto.MyAssistancesListResponse{
		Assistances:        assistances,
		AssistanceStatus:   assistanceStatusDTO,
		ResolvedCount:      resolvedCount,
		PendingReviewCount: pendingReviewCount,
		PageResponse:       dto.PageResponse{PageSize: form.PageSize, PageNum: form.PageNum, Total: total},
	})
}
