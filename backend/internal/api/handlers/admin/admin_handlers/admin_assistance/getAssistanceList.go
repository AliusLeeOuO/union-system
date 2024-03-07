package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetAssistanceList(c *fiber.Ctx) error {
	// 获取表单数据
	var form dto.GetAssistanceListRequest
	if err := c.BodyParser(&form); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"PageSize": int(form.PageSize),
		"PageNum":  int(form.PageSize),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	// 初始化 service
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))

	// 调用 service 获取数据
	assistanceList, err := assistanceService.GetAssistanceList(form)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
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
	assistanceList.AssistanceStatus = assistanceStatusDTO

	return model.SendSuccessResponse(c, assistanceList)
}
