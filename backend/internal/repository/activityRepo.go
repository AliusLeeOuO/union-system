package repository

import (
	"errors"
	"gorm.io/gorm"
	"union-system/internal/model"
)

type ActivityRepository struct {
	DB *gorm.DB
}

func NewActivityRepository(db *gorm.DB) *ActivityRepository {
	return &ActivityRepository{DB: db}
}

func (r *ActivityRepository) GetActivities(pageNum, pageSize uint) ([]model.Activity, int64, error) {
	var activities []model.Activity
	var total int64

	offset := (pageNum - 1) * pageSize
	result := r.DB.Offset(int(offset)).Limit(int(pageSize)).Find(&activities)
	r.DB.Model(&model.Activity{}).Count(&total)

	return activities, total, result.Error
}

func (r *ActivityRepository) GetActivityType() ([]model.ActivityType, error) {
	var activityType []model.ActivityType
	result := r.DB.Find(&activityType)
	return activityType, result.Error
}

func (r *ActivityRepository) GetActivityTypeById(activityId uint) (model.ActivityType, error) {
	var activity model.ActivityType
	result := r.DB.Where("activity_type_id = ?", activityId).First(&activity)
	return activity, result.Error
}

func (r *ActivityRepository) CreateActivity(activity model.Activity) (uint, error) {
	result := r.DB.Create(&activity)
	if result.Error != nil {
		return 0, result.Error
	}

	return activity.ActivityID, nil
}

func (r *ActivityRepository) EditActivity(activity model.Activity) error {
	return r.DB.Model(&model.Activity{}).
		Where("activity_id = ?", activity.ActivityID).
		Select("ActivityName", "Description", "StartTime", "EndTime", "Location", "ParticipantLimit", "ActivityTypeID", "IsActive").
		Updates(activity).Error
}

func (r *ActivityRepository) DeleteActivity(activityID uint) error {
	return r.DB.Model(&model.Activity{}).Where("activity_id = ?", activityID).Update("removed", true).Error
}

func (r *ActivityRepository) GetAllActivities(pageSize uint, pageNum uint) ([]model.Activity, uint, error) {
	var activities []model.Activity
	var totalInt int64 = 0

	// 先获取总活动数
	result := r.DB.Model(&model.Activity{}).Where("removed = ?", false).Count(&totalInt)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 获取当前页的活动列表，并计算已报名人数
	offset := (pageNum - 1) * pageSize
	result = r.DB.Model(&model.Activity{}).
		Select("tb_activity.*, COUNT(tb_user_activity.user_id) as registration_count").
		Joins("LEFT JOIN tb_user_activity ON tb_user_activity.activity_id = tb_activity.activity_id").
		Where("tb_activity.removed = ?", false).
		Group("tb_activity.activity_id").
		Offset(int(offset)).
		Limit(int(pageSize)).
		Find(&activities)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 将 model.Activity 转换为包含报名人数的 model.ActivityWithRegistrationCount
	var activitiesWithCount []model.Activity
	for _, activity := range activities {
		activitiesWithCount = append(activitiesWithCount, model.Activity{
			ActivityID:        activity.ActivityID,
			ActivityName:      activity.ActivityName,
			Description:       activity.Description,
			StartTime:         activity.StartTime,
			EndTime:           activity.EndTime,
			Location:          activity.Location,
			ParticipantLimit:  activity.ParticipantLimit,
			ActivityTypeID:    activity.ActivityTypeID,
			IsActive:          activity.IsActive,
			RegistrationCount: activity.RegistrationCount,
		})
	}

	return activitiesWithCount, uint(totalInt), nil
}

func (r *ActivityRepository) GetActivityDetails(activityID uint) (model.Activity, error) {
	var activityDetails model.Activity

	result := r.DB.Model(&model.Activity{}).
		Select("tb_activity.*, COUNT(tb_user_activity.user_id) as registration_count").
		Joins("LEFT JOIN tb_user_activity ON tb_user_activity.activity_id = tb_activity.activity_id").
		Where("tb_activity.activity_id = ? AND tb_activity.removed = ?", activityID, false).
		Group("tb_activity.activity_id").
		First(&activityDetails)

	if result.Error != nil {
		return model.Activity{}, result.Error
	}

	return activityDetails, nil
}

func (r *ActivityRepository) RegisterForActivity(userID, activityID uint) error {
	// 检查用户是否已经报名了该活动
	var count int64
	r.DB.Model(&model.UserActivity{}).Where("user_id = ? AND activity_id = ?", userID, activityID).Count(&count)
	if count > 0 {
		return errors.New("already registered for the activity")
	}

	// 添加用户到活动的报名表中
	userActivity := model.UserActivity{UserID: userID, ActivityID: activityID}
	return r.DB.Create(&userActivity).Error
}

func (r *ActivityRepository) UnregisterFromActivity(userID, activityID uint) error {
	result := r.DB.Where("user_id = ? AND activity_id = ?", userID, activityID).Delete(&model.UserActivity{})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("未报名该活动")
	}
	return nil
}

func (r *ActivityRepository) GetRegisteredActivities(userID, pageSize, pageNum uint) ([]model.Activity, uint, error) {
	var activities []model.Activity
	var total int64

	// 计算跳过的记录数
	offset := (pageNum - 1) * pageSize

	// 使用子查询找到用户已报名的活动ID
	subQuery := r.DB.Model(&model.UserActivity{}).Select("activity_id").Where("user_id = ?", userID)

	// 获取已报名活动的总数
	result := r.DB.Model(&model.Activity{}).Where("activity_id IN (?) AND removed = ?", subQuery, false).Count(&total)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 获取分页的已报名活动列表
	result = r.DB.Where("activity_id IN (?) AND removed = ?", subQuery, false).
		Offset(int(offset)).
		Limit(int(pageSize)).
		Find(&activities)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	return activities, uint(total), nil
}
