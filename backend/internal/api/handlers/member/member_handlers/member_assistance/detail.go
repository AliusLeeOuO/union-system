package member_assistance

import (
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func ViewAssistance(c *fiber.Ctx) error {
	var form dto.ViewAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	assistance, responses, err := assistanceService.ViewAssistance(form.RequestID)
	if err != nil {
		return model.SendFailureResponse(c, model.NotFoundErrorCode)
	}
	response := dto.ViewAssistanceResponse{
		ID:             assistance.RequestID,
		AssistanceType: assistance.AssistanceType.TypeName,
		Title:          assistance.Title,
		Description:    assistance.Description,
		CreatedAt:      assistance.CreatedAt.Format(time.RFC3339),
		UpdatedAt:      assistance.UpdatedAt.Format(time.RFC3339),
		Status: dto.AssistanceStatusResponse{
			ID:   assistance.AssistanceStatus.StatusID,
			Name: assistance.AssistanceStatus.StatusName,
		},
		Type: dto.GetAssistanceTypeRequest{
			AssistanceTypeId: assistance.AssistanceType.AssistanceTypeID,
			TypeName:         assistance.AssistanceType.TypeName,
		},
		Responses: []dto.AssistanceResponse{}, // 初始化 Responses 列表
	}

	// 填充 Responses 列表
	for _, resp := range responses {
		response.Responses = append(response.Responses, dto.AssistanceResponse{
			ResponseID:   resp.ResponseID,
			ResponderID:  resp.ResponderID,
			ResponseText: resp.ResponseText,
			CreatedAt:    resp.CreatedAt,
		})
	}

	return model.SendSuccessResponse(c, response)
}
