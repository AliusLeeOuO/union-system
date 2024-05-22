package admin_assistance

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func DeleteType(c *fiber.Ctx) error {
	// 从 URL 路径参数中获取ID
	assistanceTypeID := c.Params("typeId")
	// 转换为 uint 类型
	assistanceTypeIDConverter, err := strconv.ParseUint(assistanceTypeID, 10, 64)
	if err != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	assistanceTypeIDUint := uint(assistanceTypeIDConverter)
	// 初始化 service
	assistanceService := service.NewAssistanceService(repository.NewAssistanceRepository(global.Database))
	// 调用 service 删除数据
	err = assistanceService.DeleteAssistanceType(assistanceTypeIDUint)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return models.SendFailureResponse(c, models.QueryParamErrorCode, err.Error())
	}
	return models.SendSuccessResponse(c, nil)
}
