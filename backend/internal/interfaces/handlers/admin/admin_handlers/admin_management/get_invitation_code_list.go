package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	dto2 "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetInvitationCodesHandler(c *fiber.Ctx) error {
	// 获取表单数据
	var validate = validator.New()
	var form dto2.Pagination
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	// 通过服务层调用分页查询
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	codes, total, err := userService.GetInvitationCodes(form.PageNum, form.PageSize)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	response := dto2.InvitationCodeListResponse{
		PageResponse: dto2.PageResponse{
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
			Total:    total,
		},
		Data: codes,
	}

	// 构建并返回响应
	return models.SendSuccessResponse(c, response)
}
