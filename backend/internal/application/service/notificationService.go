package service

import (
	dto2 "union-system/internal/application/dto"
	"union-system/internal/infrastructure/repository"
)

type NotificationService struct {
	Repo *repository.NotificationRepository
}

func NewNotificationService(repo *repository.NotificationRepository) *NotificationService {
	return &NotificationService{Repo: repo}
}

func (service *NotificationService) GetNotificationsByRecipientID(recipientID uint, pageSize uint, pageNum uint) (dto2.NotificationPageResponse, error) {
	notificationsWithStatus, total, err := service.Repo.FindNotificationsByRecipientID(recipientID, pageSize, pageNum)
	if err != nil {
		return dto2.NotificationPageResponse{}, err
	}

	var dtos []dto2.NotificationInstance
	for _, n := range notificationsWithStatus {
		buffer := dto2.NotificationInstance{
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

	return dto2.NotificationPageResponse{
		PageResponse: dto2.PageResponse{
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
