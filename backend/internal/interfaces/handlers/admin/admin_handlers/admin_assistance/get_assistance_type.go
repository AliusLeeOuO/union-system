package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetAssistanceType(c *fiber.Ctx) error {
	var request []dto.GetAssistanceTypeRequest

	// 初始化 service
	assistanceTypeService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	// 调用 service 获取数据
	request, err := assistanceTypeService.GetAssistanceType(c)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	return models.SendSuccessResponse(c, request)
}
