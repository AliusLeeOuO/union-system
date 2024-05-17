package service

import (
	"errors"
	"github.com/gofiber/fiber/v2"
	"time"
	dto "union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
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

func (s *ActivityService) GetActivityTypeById(c *fiber.Ctx, activityId uint) (dto.GetActivityTypeRequest, error) {
	activity, err := s.Repo.GetActivityTypeById(c, activityId)
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

	activity := domain.Activity{
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
	activity := domain.Activity{
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

func (s *ActivityService) GetAllActivities(c *fiber.Ctx, pageSize uint, pageNum uint) ([]dto.ActivityResponse, uint, error) {
	activities, total, err := s.Repo.GetAllActivities(pageSize, pageNum)
	if err != nil {
		return nil, 0, err
	}

	// 使用map来存储活动类型，避免重复查询
	activityTypeMap := make(map[uint]domain.ActivityType)

	var activityResponses []dto.ActivityResponse
	for _, activity := range activities {
		var resp = dto.ActivityResponse{
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
		}
		// 查询活动类型
		if _, ok := activityTypeMap[activity.ActivityTypeID]; !ok {
			activityType, getTypeError := s.Repo.GetActivityTypeById(c, activity.ActivityTypeID)
			if getTypeError != nil {
				return nil, 0, err
			}
			activityTypeMap[activity.ActivityTypeID] = activityType
		}
		resp.ActivityTypeName = activityTypeMap[activity.ActivityTypeID].TypeName
		activityResponses = append(activityResponses, resp)
	}

	return activityResponses, total, nil
}

// GetActivityUserRegistrations 获取活动的报名用户
func (s *ActivityService) GetActivityUserRegistrations(activityID uint) ([]dto.ActivityRegistrationResponse, error) {
	// 查询报名用户
	registrations, err := s.Repo.GetActivityUserRegistrations(activityID)
	if err != nil {
		return nil, err
	}

	var registrationResponses []dto.ActivityRegistrationResponse
	for _, registration := range registrations {
		registrationResponses = append(registrationResponses, dto.ActivityRegistrationResponse{
			UserId:   registration.UserID,
			UserName: registration.Username,
			Phone:    registration.PhoneNumber,
			Email:    registration.Email,
		})
	}

	return registrationResponses, nil
}

func (s *ActivityService) GetActivityDetails(c *fiber.Ctx, activityID uint) (dto.ActivityResponse, error) {
	activityDetails, err := s.Repo.GetActivityDetails(activityID)
	if err != nil {
		return dto.ActivityResponse{}, err
	}

	// 查询ActivityTypeName
	activityType, err := s.Repo.GetActivityTypeById(c, activityDetails.ActivityTypeID)

	// 将 models.ActivityWithRegistrationCount 映射到 dto.ActivityDetailsResponse
	return dto.ActivityResponse{
		ActivityID:        activityDetails.ActivityID,
		Title:             activityDetails.ActivityName,
		Description:       activityDetails.Description,
		StartTime:         activityDetails.StartTime.Format(time.RFC3339),
		EndTime:           activityDetails.EndTime.Format(time.RFC3339),
		Location:          activityDetails.Location,
		MaxParticipants:   activityDetails.ParticipantLimit,
		ActivityTypeID:    activityDetails.ActivityTypeID,
		ActivityTypeName:  activityType.TypeName,
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

// GetUserActivityRegistrationStatus 获取用户是否报名了某个活动
func (s *ActivityService) GetUserActivityRegistrationStatus(userID, activityID uint) bool {
	return s.Repo.CheckRegisterForActivity(userID, activityID)
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

func (s *ActivityService) GetRegisteredActivities(c *fiber.Ctx, userID, pageSize, pageNum uint) ([]dto.ActivityResponse, uint, error) {
	activities, total, err := s.Repo.GetRegisteredActivities(userID, pageSize, pageNum)
	if err != nil {
		return nil, 0, err
	}

	// 使用map来存储活动类型，避免重复查询
	activityTypeMap := make(map[uint]domain.ActivityType)

	var activityResponses []dto.ActivityResponse
	for _, activity := range activities {
		var resp = dto.ActivityResponse{
			ActivityID:      activity.ActivityID,
			Title:           activity.ActivityName,
			Description:     activity.Description,
			StartTime:       activity.StartTime.Format(time.RFC3339),
			EndTime:         activity.EndTime.Format(time.RFC3339),
			Location:        activity.Location,
			MaxParticipants: activity.ParticipantLimit,
			ActivityTypeID:  activity.ActivityTypeID,
			IsActive:        activity.IsActive,
		}

		// 查询活动类型
		if _, ok := activityTypeMap[activity.ActivityTypeID]; !ok {
			activityType, getTypeError := s.Repo.GetActivityTypeById(c, activity.ActivityTypeID)
			if getTypeError != nil {
				return nil, 0, err
			}
			activityTypeMap[activity.ActivityTypeID] = activityType
		}
		resp.ActivityTypeName = activityTypeMap[activity.ActivityTypeID].TypeName
		activityResponses = append(activityResponses, resp)
	}

	return activityResponses, total, nil
}

// ModifyActivityTitle 修改活动标题
func (s *ActivityService) ModifyActivityTitle(activityID uint, title string) error {
	return s.Repo.ChangeActivityTitle(activityID, title)
}

// ModifyActivityDescription 修改活动描述
func (s *ActivityService) ModifyActivityDescription(activityID uint, description string) error {
	return s.Repo.ChangeActivityDescription(activityID, description)
}

// ModifyActivityLocation 修改活动地点
func (s *ActivityService) ModifyActivityLocation(activityID uint, location string) error {
	return s.Repo.ChangeActivityLocation(activityID, location)
}

// CreateActivityType 创建活动类型
func (s *ActivityService) CreateActivityType(typeName string) (uint, error) {
	// 检查是否存在
	exist := s.Repo.CheckActivityTypeExist(typeName)
	if exist {
		return 0, errors.New("活动类型已存在")
	}
	return s.Repo.CreateActivityType(typeName)
}

// DeleteActivityType 删除活动类型
func (s *ActivityService) DeleteActivityType(typeID uint) error {
	exist := s.Repo.CheckActivityTypeExistByID(typeID)
	if !exist {
		return errors.New("活动类型不存在")
	}
	return s.Repo.DeleteActivityType(typeID)
}
