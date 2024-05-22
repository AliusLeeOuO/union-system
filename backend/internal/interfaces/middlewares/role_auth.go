package middlewares

import (
	"github.com/gofiber/fiber/v2"
	"union-system/global"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
	"union-system/utils/build_permission_tree"
)

// checkPermission 递归检查权限
func checkPermission(permissions []*build_permission_tree.PermissionNode, path string) bool {
	for _, v := range permissions {
		if v.PermissionNode == path {
			return true
		}
		if checkPermission(v.Children, path) {
			return true
		}
	}
	return false
}

func RoleAuth(c *fiber.Ctx) error {
	// 读取用户信息
	userID := c.Locals("userID").(uint)
	// 读取请求路径
	path := c.Path()
	// 初始化 service 查询用户权限
	userService := service.NewUserService(repository.NewUserRepository(global.Database))
	permissions, err := userService.GetPermissions(c, userID)
	if err != nil {
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}
	// 从权限列表中递归查找是否有权限
	if !checkPermission(permissions, path) {
		return models.SendFailureResponse(c, models.AuthFailedCode)
	}
	return c.Next()
}
