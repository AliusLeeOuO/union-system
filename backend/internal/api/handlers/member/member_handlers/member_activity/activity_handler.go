package member_activity

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	activity := app.Group("/activity")

	// 注册路由
	activity.Post("/list", GetActivitiesHandler)
	activity.Get("/type", GetActivityType)
	activity.Get("/detail/:activityId", GetActivityDetails)
	activity.Post("/register/:activityId", RegisterForActivity)
	//activity.Post("/feedback/{activityId}")
	activity.Delete("/cancel/:activityId", UnregisterFromActivity)
	activity.Get("/history", GetRegisteredActivities)
}
