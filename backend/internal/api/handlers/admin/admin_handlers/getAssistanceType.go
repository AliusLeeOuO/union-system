package admin_handlers

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
	assistanceTypeRepo := repository.NewAdminRepository(global.Database)
	assistanceTypeService := service.NewAdminService(assistanceTypeRepo)
	// 调用 service 获取数据
	request, err := assistanceTypeService.GetAssistanceType()
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	return model.SendSuccessResponse(c, request)
}
