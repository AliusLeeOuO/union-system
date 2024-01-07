package admin_assistance

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"strconv"
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
	// 打印字段
	fmt.Println("GetAssistanceList:")
	fmt.Println(form)
	// 验证字段
	fieldsToCheck := map[string]string{
		"PageSize": strconv.Itoa(int(form.PageSize)),
		"PageNum":  strconv.Itoa(int(form.PageNum)),
	}
	ok, missingField := check_fields.CheckFields(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}
	// 初始化 service
	assistanceRepo := repository.NewAssistanceRepository(global.Database)
	assistanceService := service.NewAssistanceService(assistanceRepo)

	// 调用 service 获取数据
	assistanceList, err := assistanceService.GetAssistanceList(form)
	if err != nil {
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}
	return model.SendSuccessResponse(c, assistanceList)
}
