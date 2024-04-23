package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func ViewAssistance(c *fiber.Ctx) error {
	var form dto2.ViewAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	assistance, responses, err := assistanceService.ViewAssistance(form.RequestID)
	if err != nil {
		return models.SendFailureResponse(c, models.NotFoundErrorCode)
	}
	response := dto2.ViewAssistanceResponse{
		ID:             assistance.RequestID,
		AssistanceType: assistance.AssistanceType.TypeName,
		Title:          assistance.Title,
		Description:    assistance.Description,
		CreatedAt:      assistance.CreatedAt.Format(time.RFC3339),
		UpdatedAt:      assistance.UpdatedAt.Format(time.RFC3339),
		Status: dto2.AssistanceStatusResponse{
			ID:   assistance.AssistanceStatus.StatusID,
			Name: assistance.AssistanceStatus.StatusName,
		},
		Type: dto2.GetAssistanceTypeRequest{
			AssistanceTypeId: assistance.AssistanceType.AssistanceTypeID,
			TypeName:         assistance.AssistanceType.TypeName,
		},
		Responses: []dto2.AssistanceResponse{}, // 初始化 Responses 列表
	}

	// 填充 Responses 列表
	for _, resp := range responses {
		response.Responses = append(response.Responses, dto2.AssistanceResponse{
			ResponseID:   resp.ResponseID,
			ResponderID:  resp.ResponderID,
			ResponseText: resp.ResponseText,
			CreatedAt:    resp.CreatedAt,
			Username:     resp.User.Username,
		})
	}

	return models.SendSuccessResponse(c, response)
}
