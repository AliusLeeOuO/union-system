package service

import (
	"errors"
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

func (s *ActivityService) GetAllActivities(pageSize uint, pageNum uint) ([]dto.ActivityResponse, uint, error) {
	activities, total, err := s.Repo.GetAllActivities(pageSize, pageNum)
	if err != nil {
		return nil, 0, err
	}

	var activityResponses []dto.ActivityResponse
	for _, activity := range activities {
		activityResponses = append(activityResponses, dto.ActivityResponse{
			ActivityID:        activity.ActivityID,
			Title:             activity.ActivityName,
			Description:       activity.Description,
			StartTime:         activity.StartTime.Format(time.RFC3339),
			EndTime:           activity.EndTime.Format(time.RFC3339),
			Location:          activity.Location,
			MaxParticipants:   activity.ParticipantLimit,
			ActivityTypeID:    activity.ActivityTypeID,
			IsActive:          activity.IsActive,
			RegistrationCount: activity.RegistrationCount,
		})
	}

	return activityResponses, total, nil
}

func (s *ActivityService) GetActivityDetails(activityID uint) (dto.ActivityResponse, error) {
	activityDetails, err := s.Repo.GetActivityDetails(activityID)
	if err != nil {
		return dto.ActivityResponse{}, err
	}

	// 将 model.ActivityWithRegistrationCount 映射到 dto.ActivityDetailsResponse
	return dto.ActivityResponse{
		ActivityID:        activityDetails.ActivityID,
		Title:             activityDetails.ActivityName,
		Description:       activityDetails.Description,
		StartTime:         activityDetails.StartTime.Format(time.RFC3339),
		EndTime:           activityDetails.EndTime.Format(time.RFC3339),
		Location:          activityDetails.Location,
		MaxParticipants:   activityDetails.ParticipantLimit,
		ActivityTypeID:    activityDetails.ActivityTypeID,
		RegistrationCount: activityDetails.RegistrationCount,
		IsActive:          activityDetails.IsActive,
	}, nil
}

func (s *ActivityService) RegisterForActivity(userID, activityID uint) error {
	// 获取活动详情
	activity, err := s.Repo.GetActivityDetails(activityID)
	if err != nil {
		return err
	}

	// 检查活动是否被关闭或已经过了活动时间
	if !activity.IsActive || activity.Removed || time.Now().After(activity.EndTime) {
		return errors.New("活动已关闭或已过期")
	}

	// 检查报名人数是否已达到限制
	if activity.RegistrationCount >= activity.ParticipantLimit {
		return errors.New("活动报名人数已满")
	}

	// 执行报名操作
	return s.Repo.RegisterForActivity(userID, activityID)
}

func (s *ActivityService) UnregisterFromActivity(userID, activityID uint) error {
	// 获取活动详情
	activity, err := s.Repo.GetActivityDetails(activityID)
	if err != nil {
		return err
	}

	// 检查是否超出了取消报名的时间（例如，活动开始前）
	if time.Now().After(activity.EndTime) {
		return errors.New("活动已开始，无法取消报名")
	}

	// 执行取消报名操作
	return s.Repo.UnregisterFromActivity(userID, activityID)
}

func (s *ActivityService) GetRegisteredActivities(userID, pageSize, pageNum uint) ([]dto.ActivityResponse, uint, error) {
	activities, total, err := s.Repo.GetRegisteredActivities(userID, pageSize, pageNum)
	if err != nil {
		return nil, 0, err
	}

	var activityResponses []dto.ActivityResponse
	for _, activity := range activities {
		activityResponses = append(activityResponses, dto.ActivityResponse{
			ActivityID:      activity.ActivityID,
			Title:           activity.ActivityName,
			Description:     activity.Description,
			StartTime:       activity.StartTime.Format(time.RFC3339),
			EndTime:         activity.EndTime.Format(time.RFC3339),
			Location:        activity.Location,
			MaxParticipants: activity.ParticipantLimit,
			ActivityTypeID:  activity.ActivityTypeID,
			IsActive:        activity.IsActive,
		})
	}

	return activityResponses, total, nil
}
