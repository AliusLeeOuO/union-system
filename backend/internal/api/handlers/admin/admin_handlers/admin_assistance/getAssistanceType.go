package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetAssistanceType(c *fiber.Ctx) error {
	var request []dto.GetAssistanceTypeRequest

	// 初始化 service
	assistanceTypeService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	// 调用 service 获取数据
	request, err := assistanceTypeService.GetAssistanceType(c)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	return model.SendSuccessResponse(c, request)
}
