package service

import (
	"time"
	"union-system/internal/dto"
	"union-system/internal/model"
	"union-system/internal/repository"
)

type ActivityService struct {
	Repo *repository.ActivityRepository
}

func NewActivityService(repo *repository.ActivityRepository) *ActivityService {
	return &ActivityService{Repo: repo}
}

func (s *ActivityService) ListActivities(pagination dto.Pagination) (dto.ActivityListResponse, error) {
	activities, total, err := s.Repo.GetActivities(pagination.PageNum, pagination.PageSize)
	if err != nil {
		return dto.ActivityListResponse{}, err
	}

	var activityItems []dto.ActivityItem
	for _, act := range activities {
		activityItems = append(activityItems, dto.ActivityItem{
			ID:          act.ActivityID,
			Name:        act.ActivityName,
			Description: act.Description,
			StartTime:   act.StartTime.Format(time.RFC3339),
			EndTime:     act.EndTime.Format(time.RFC3339),
		})
	}

	return dto.ActivityListResponse{
		PageResponse: dto.PageResponse{
			PageSize: pagination.PageSize,
			PageNum:  pagination.PageNum,
			Total:    uint(total),
		},
		Activities: activityItems,
	}, nil
}

func (s *ActivityService) GetActivityType() ([]dto.GetActivityTypeRequest, error) {
	activityType, err := s.Repo.GetActivityType()
	if err != nil {
		return nil, err
	}
	var activityTypeRequest []dto.GetActivityTypeRequest
	for _, act := range activityType {
		activityTypeRequest = append(activityTypeRequest, dto.GetActivityTypeRequest{
			ActivityTypeId: act.ActivityTypeID,
			TypeName:       act.TypeName,
		})
	}
	return activityTypeRequest, nil
}

func (s *ActivityService) GetActivityTypeById(activityId uint) (dto.GetActivityTypeRequest, error) {
	activity, err := s.Repo.GetActivityTypeById(activityId)
	if err != nil {
		return dto.GetActivityTypeRequest{}, err
	}
	return dto.GetActivityTypeRequest{
		ActivityTypeId: activity.ActivityTypeID,
		TypeName:       activity.TypeName,
	}, nil
}

func (s *ActivityService) CreateActivity(req dto.CreateOrModifyActivityRequest, creatorId uint) (uint, error) {
	// 将请求的时间字符串转换为 time.Time 类型
	startTime, err := time.Parse(time.RFC3339, req.StartTime)
	if err != nil {
		return 0, err
	}
	endTime, err := time.Parse(time.RFC3339, req.EndTime)
	if err != nil {
		return 0, err
	}

	activity := model.Activity{
		ActivityName:     req.Title,
		Description:      req.Description,
		StartTime:        startTime,
		EndTime:          endTime,
		Location:         req.Location,
		ActivityTypeID:   req.Type,
		ParticipantLimit: req.MaxParticipants,
		CreatorID:        creatorId,
		IsActive:         req.IsActive,
	}

	id, err := s.Repo.CreateActivity(activity)
	if err != nil {
		return 0, err
	}

	return id, nil
}

func (s *ActivityService) EditActivity(activityID uint, req dto.CreateOrModifyActivityRequest) (uint, error) {
	// 转换时间
	startTime, _ := time.Parse(time.RFC3339, req.StartTime)
	endTime, _ := time.Parse(time.RFC3339, req.EndTime)

	// 构造一个活动对象
	activity := model.Activity{
		ActivityID:       activityID,
		ActivityName:     req.Title,
		Description:      req.Description,
		StartTime:        startTime, // StartTime 和 EndTime 已在 handler 中解析
		EndTime:          endTime,
		Location:         req.Location,
		ParticipantLimit: req.MaxParticipants,
		ActivityTypeID:   req.Type,
		IsActive:         req.IsActive,
	}

	// 调用 repository 层来更新活动
	err := s.Repo.EditActivity(activity)
	if err != nil {
		return 0, err
	}

	return activityID, nil
}

func (s *ActivityService) DeleteActivity(activityID uint) error {
	return s.Repo.DeleteActivity(activityID)
}
