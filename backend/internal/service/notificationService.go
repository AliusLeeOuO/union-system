package service

import (
	"union-system/internal/dto"
	"union-system/internal/repository"
)

type NotificationService struct {
	Repo *repository.NotificationRepository
}

func NewNotificationService(repo *repository.NotificationRepository) *NotificationService {
	return &NotificationService{Repo: repo}
}

func (service *NotificationService) GetNotificationsByRecipientID(recipientID uint, pageSize uint, pageNum uint) (dto.NotificationPageResponse, error) {
	notificationsWithStatus, total, err := service.Repo.FindNotificationsByRecipientID(recipientID, pageSize, pageNum)
	if err != nil {
		return dto.NotificationPageResponse{}, err
	}

	var dtos []dto.NotificationInstance
	for _, n := range notificationsWithStatus {
		buffer := dto.NotificationInstance{
			NotificationID: n.NotificationID,
			Title:          n.Title,
			Content:        n.Content,
			CreatedAt:      n.CreatedAt,
			ReadStatus:     n.ReadStatus,
			SenderName:     n.SenderName,
			SenderRole:     n.SenderRole,
		}
		dtos = append(dtos, buffer)
	}

	return dto.NotificationPageResponse{
		PageResponse: dto.PageResponse{
			PageSize: pageSize,
			PageNum:  pageNum,
			Total:    total,
		},
		Notifications: dtos,
	}, nil
}

// MarkAsRead 实现 MarkAsRead 方法
func (service *NotificationService) MarkAsRead(notificationID uint, userID uint) error {
	return service.Repo.MarkNotificationAsRead(notificationID, userID)
}

func (service *NotificationService) MarkAllAsRead(userID uint) error {
	return service.Repo.MarkAllNotificationsAsRead(userID)
}

func (service *NotificationService) GetUnreadNotificationCount(userID uint) (uint, error) {
	return service.Repo.CountUnreadNotifications(userID)
}
