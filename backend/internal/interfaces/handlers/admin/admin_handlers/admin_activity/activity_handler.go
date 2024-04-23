package admin_activity

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	activity := app.Group("/activity")

	// 注册路由
	activity.Post("/list", ListActivitiesHandler)
	activity.Get("/detail/:activityId", GetActivityDetails)
	activity.Get("/type", GetActivityType)
	activity.Post("/create", CreateActivityHandler)
	activity.Put("/edit/:activityId", ModifyActivityHandler)
	activity.Post("/delete/:activityId", DeleteActivityHandler)
	activity.Post("/cancelUserReg", UnregisterUserRegister)
	activity.Post("/modifyTitle", ModifyActivityTitle)
	activity.Post("/modifyDescription", ModifyActivityDescription)
	activity.Post("/modifyLocation", ModifyActivityLocation)
	//activity.Get("/registrations/:activityId")
	//activity.Post("/notify/{activityId}")
	//activity.Get("/history")
}
