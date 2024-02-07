package repository

import (
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

	// 获取当前页的活动列表
	offset := (pageNum - 1) * pageSize
	result = r.DB.Where("removed = ?", false).
		Offset(int(offset)).
		Limit(int(pageSize)).
		Find(&activities)
	if result.Error != nil {
		return nil, 0, result.Error
	}

	return activities, uint(totalInt), nil
}
