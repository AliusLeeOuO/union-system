package member_activity

import (
	"github.com/gofiber/fiber/v2"
	"strconv"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetActivitiesHandler(c *fiber.Ctx) error {
	// 解析分页参数
	pageSize, _ := strconv.Atoi(c.Query("page_size", "10")) // 默认每页10条
	pageNum, _ := strconv.Atoi(c.Query("page_num", "1"))    // 默认第一页

	activityService := service.NewActivityService(repository.NewActivityRepository(global.Database))
	activities, total, err := activityService.GetAllActivities(uint(pageSize), uint(pageNum))
	if err != nil {
		return model.SendFailureResponse(c, model.InternalServerErrorCode, err.Error())
	}

	return c.JSON(dto.UserGetActivityListResponse{
		Data: activities,
		PageResponse: dto.PageResponse{
			PageSize: uint(pageSize),
			PageNum:  uint(pageNum),
			Total:    total,
		},
	})
}
