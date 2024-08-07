package admin_management

import (
	"github.com/gofiber/fiber/v2"
)

func Init(app fiber.Router) {
	management := app.Group("/management")
	// 注册路由
	management.Post("/getUserList", GetUserList)
	management.Post("/addNewUser", AddNewUser)
	management.Post("/getUserInfo", GetUserInfoHandler)
	management.Post("/updateUser", UpdateUserHandler)
	management.Post("/getLoginList", GetLoginList)
	management.Post("/getAdminLogList", GetAdminLogList)
	management.Post("/getInvitationCodeList", GetInvitationCodesHandler)
	management.Post("/generateInvitationCode", GenerateInvitationCodeHandler)
	management.Post("/getLogAdminList", GetLogAdmin)
	management.Post("/getLogMemberList", GetLogMember)
	management.Get("/getPermissionList/:userInfo", GetPermissionList)
	management.Post("/getPermissionGroup", GetPermissionGroup)
	management.Get("/getRoleGroup", GetRoleGroup)
	management.Post("/permissionNode", NewPermissionNode)
	management.Get("/permissionNode/:type", GetPermissionNodeByType)
	management.Delete("/permissionNode/:nodeId", DeletePermissionNode)
	management.Post("/permissionGroup", AddPermissionGroup)
	management.Delete("/permissionGroup/:permissionGroup", DeletePermissionGroup)
	management.Put("/permissionGroup", ModifyGroupPermissions)

	// 添加 WebSocket 路由
	// 初始化PubSub实例
	pubsub := NewPubSub()
	go pubsub.run()
	// 使用剥离的函数注册WebSocket路由
	management.Get("/deviceInfo", handleDeviceInfoWebSocket(pubsub))
}
