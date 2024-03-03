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
	notifications, total, err := service.Repo.FindNotificationsByRecipientID(recipientID, pageSize, pageNum)
	if err != nil {
		return dto.NotificationPageResponse{}, err
	}

	var dtos []dto.NotificationInstance
	for _, n := range notifications {
		buffer := dto.NotificationInstance{
			NotificationID: n.NotificationID,
			Title:          n.Title,
			Content:        n.Content,
			CreatedAt:      n.CreatedAt,
			// ReadStatus 需要根据NotificationRecipient来设置
			ReadStatus: false, // 假设默认未读，需要根据实际情况调整
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
