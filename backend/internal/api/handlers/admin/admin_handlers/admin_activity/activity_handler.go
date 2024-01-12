package admin_activity

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	activity := app.Group("/activity")

	// 注册路由
	activity.Post("/list", ListActivitiesHandler)
	activity.Get("/type", GetActivityType)
	activity.Post("/create", CreateActivityHandler)
	activity.Put("/edit/:activityId", ModifyActivityHandler)
	activity.Delete("/delete/:activityId", DeleteActivityHandler)
	//activity.Get("/registrations/:activityId")
	//activity.Post("/notify/{activityId}")
	//activity.Get("/history")
}
