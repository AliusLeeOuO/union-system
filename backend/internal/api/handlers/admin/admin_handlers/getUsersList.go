package admin_handlers

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetUserList(c *fiber.Ctx) error {
	var request dto.GetUserListRequest
	if err := c.BodyParser(&request); err != nil {
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	// 校验字段
	fieldsToCheck := map[string]interface{}{
		"pageSize": int(request.PageSize),
		"pageNum":  int(request.PageNum),
	}
	ok, missingField := check_fields.CheckFieldsWithDefaults(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	adminUsers, total, err := userService.GetAdminUsers(int(request.PageNum), int(request.PageSize), request.Username, request.ID, request.Role)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Internal server error"})
	}

	var adminUsersResponse []dto.GetAdminUserResponse
	for _, user := range adminUsers {
		adminUsersResponse = append(adminUsersResponse, dto.GetAdminUserResponse{
			ID:       user.UserID,
			Username: user.Username,
			Role:     user.UserTypeID,
			Status:   user.IsActive,
		})
	}

	return model.SendSuccessResponse(c, dto.GetAdminUserListResponse{
		Data: adminUsersResponse,
		PageResponse: dto.PageResponse{
			PageSize: uint(request.PageSize),
			PageNum:  uint(request.PageNum),
			Total:    uint(total),
		},
	})
}
