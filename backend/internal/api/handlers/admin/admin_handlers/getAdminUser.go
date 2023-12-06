package admin_handlers

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
	"union-system/utils/check_fields"
)

func GetUserList(c *fiber.Ctx) error {
	var request dto.GetAdminUserListRequest
	if err := c.BodyParser(&request); err != nil {
		// 解析错误处理
		// 使用 BaseResponse 发送错误响应
		return model.SendFailureResponse(c, model.QueryParamErrorCode)
	}

	fieldsToCheck := map[string]string{
		"pageSize": strconv.Itoa(int(request.PageSize)),
		"pageNum":  strconv.Itoa(int(request.PageNum)),
	}
	ok, missingField := check_fields.CheckFields(fieldsToCheck)
	if !ok {
		errorMessage := "缺少必要字段: " + missingField
		return model.SendFailureResponse(c, model.QueryParamErrorCode, errorMessage)
	}

	// 获取分页参数
	pageSize := int(request.PageSize)
	pageNum := int(request.PageNum)

	// 初始化 service
	userRepo := repository.NewUserRepository(global.Database)
	userService := service.NewUserService(userRepo)

	// 调用 service 获取数据
	adminUsers, err := userService.GetAdminUsers(pageNum, pageSize)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Internal server error"})
	}

	// 转换为 DTO 列表
	var adminUsersResponse []dto.GetAdminUserListResponse
	for _, user := range adminUsers {
		adminUsersResponse = append(adminUsersResponse, dto.GetAdminUserListResponse{
			ID:       user.ID,
			Username: user.Username,
			Role:     user.Role,
			Status:   user.Status,
		})
	}

	return c.JSON(fiber.Map{
		"data":     adminUsersResponse,
		"page":     pageNum,
		"pageSize": pageSize,
	})
}
