package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/user_role_enum"
)

func GetPermissionList(c *fiber.Ctx) error {
	userParam := c.Params("userInfo")

	var permissions []domain.UserType
	adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))

	if userParam == user_role_enum.MEMBER || userParam == user_role_enum.ADMIN {
		userType, err := adminService.GetAllowPermissionsByUserType(userParam)
		if err != nil {
			return err
		}
		permissions = append(permissions, userType...)
	} else {
		// 如果是数字，说明是用户ID
		// 转换为uint
		userIDUint64, err := strconv.ParseUint(userParam, 10, 64)
		if err != nil {
			return models.SendFailureResponse(c, models.QueryParamErrorCode)
		}
		userID := uint(userIDUint64)
		permissions, err = adminService.GetAllowPermissionsByUserID(userID)
		if err != nil {
			return models.SendFailureResponse(c, models.ResourceNotFoundCode)
		}
	}
	if len(permissions) == 0 {
		return models.SendSuccessResponse(c, []interface{}{})
	}
	return models.SendSuccessResponse(c, permissions)
}
