package admin_management

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	dto "union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

func GetUserList(c *fiber.Ctx) error {
	var validate = validator.New()
	var request dto.GetUserListRequest
	if err := c.BodyParser(&request); err != nil || validate.Struct(request) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}

	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	adminUsers, total, err := userService.GetUserList(int(request.PageNum), int(request.PageSize), request.Username, request.ID, request.Role)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode)
	}

	var adminUsersResponse []dto.GetAdminUserResponse
	for _, user := range adminUsers {
		adminUsersResponse = append(adminUsersResponse, dto.GetAdminUserResponse{
			ID:         user.UserID,
			Username:   user.Username,
			Role:       user.UserTypeID,
			Status:     user.IsActive,
			CreateTime: user.RegistrationDate.Format(time.RFC3339),
		})
	}

	return models.SendSuccessResponse(c, dto.GetAdminUserListResponse{
		Data: adminUsersResponse,
		PageResponse: dto.PageResponse{
			PageSize: request.PageSize,
			PageNum:  request.PageNum,
			Total:    uint(total),
		},
	})
}
