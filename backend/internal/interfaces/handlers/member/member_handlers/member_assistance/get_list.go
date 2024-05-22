package member_assistance

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetMyAssistances(c *fiber.Ctx) error {
	var validate = validator.New()
	var form dto.ActivityListRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	memberID := c.Locals("userID").(uint) // 用户ID已经通过认证中间件设置
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	assistances, total, resolvedCount, pendingReviewCount, err := assistanceService.GetMyAssistances(memberID, form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, "无法获取工单列表")
	}

	// 获取status类型
	assistanceStatus, err := assistanceService.GetAssistanceStatus(c)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, "无法获取工单状态")
	}
	// 整理成dto
	assistanceStatusDTO := make([]dto.AssistanceStatusDTO, 0)
	for _, status := range assistanceStatus {
		assistanceStatusDTO = append(assistanceStatusDTO, dto.AssistanceStatusDTO{
			StatusID:   status.ID,
			StatusName: status.Name,
		})
	}

	return models.SendSuccessResponse(c, dto.MyAssistancesListResponse{
		Assistances:        assistances,
		AssistanceStatus:   assistanceStatusDTO,
		ResolvedCount:      resolvedCount,
		PendingReviewCount: pendingReviewCount,
		PageResponse:       dto.PageResponse{PageSize: form.PageSize, PageNum: form.PageNum, Total: total},
	})
}
