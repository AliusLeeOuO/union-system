package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetLoginList(c *fiber.Ctx) error {
	var req dto.LoginLogListRequest
	if err := c.BodyParser(&req); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 验证字段
	fieldsToCheck := map[string]interface{}{
		"page_size": req.PageSize,
		"page_num":  req.PageNum,
		"status":    req.Status,
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	if req.Status != "all" && req.Status != "true" && req.Status != "false" {
		return model.SendFailureResponse(c, model.QueryParamErrorCode, "status字段不合法")
	}

	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
	logs, total, err := adminService.GetLogLoginsByPage(req.PageSize, req.PageNum, req.Status)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	// 返回分页响应
	return model.SendSuccessResponse(c, dto.GetLoginLogListResponse{
		PageResponse: dto.PageResponse{
			PageSize: req.PageSize,
			PageNum:  req.PageNum,
			Total:    total,
		},
		Data: logs,
	})
}
