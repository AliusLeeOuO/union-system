package member_activity

import "github.com/gofiber/fiber/v2"

func Init(app fiber.Router) {
	activity := app.Group("/activity")

	// 注册路由
	activity.Post("/list", GetActivitiesHandler)
	//activity.Get("/detail/{activityId}")
	//activity.Post("/register/{activityId}")
	//activity.Post("/feedback/{activityId}")
	//activity.Delete("/cancel/{activityId}")
	//activity.Get("/history")
}
