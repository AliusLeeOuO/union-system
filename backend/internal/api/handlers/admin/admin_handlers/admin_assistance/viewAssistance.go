package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto/dto_admin"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func ViewAssistance(c *fiber.Ctx) error {
	var form dto_admin.ViewAssistanceRequest
	if err := c.BodyParser(&form); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	assistance, responses, err := assistanceService.ViewAssistance(form.RequestID)
	if err != nil {
		return model.SendFailureResponse(c, model.NotFoundErrorCode)
	}

	response := dto_admin.ViewAssistanceResponse{
		ID:             assistance.RequestID,
		AssistanceType: assistance.AssistanceType.TypeName,
		Title:          assistance.Title,
		Description:    assistance.Description,
		Status: dto_admin.AssistanceStatusResponse{
			ID:   assistance.AssistanceStatus.StatusID,
			Name: assistance.AssistanceStatus.StatusName,
		},
		Responses: []dto_admin.AssistanceResponse{}, // 初始化 Responses 列表
	}

	// 填充 Responses 列表
	for _, resp := range responses {
		response.Responses = append(response.Responses, dto_admin.AssistanceResponse{
			ResponderID:  resp.ResponderID,
			ResponseText: resp.ResponseText,
			CreatedAt:    resp.CreatedAt,
		})
	}

	return model.SendSuccessResponse(c, response)
}
