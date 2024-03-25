package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"
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

	// 添加 WebSocket 路由
	management.Get("/deviceInfo", websocket.New(handleWebSocket))
}
