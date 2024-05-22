package service

import (
	dto "union-system/internal/application/dto"
	"union-system/internal/domain"
	"union-system/internal/infrastructure/repository"
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

func (service *NotificationService) GetNotificationsByRecipientIDNew(recipientID uint, pageSize uint, pageNum uint) (dto.NotificationPageResponse, error) {
	// Step 1: Fetch notifications with status
	notificationRecipients, err := service.Repo.FindNotificationRecipientsByRecipientID(recipientID, pageSize, pageNum)
	if err != nil {
		return dto.NotificationPageResponse{}, err
	}

	// Step 2: Fetch notifications
	notificationIDs := make([]uint, len(notificationRecipients))
	for i, nr := range notificationRecipients {
		notificationIDs[i] = nr.NotificationID
	}

	notifications, err := service.Repo.FindNotificationsByIDs(notificationIDs)
	if err != nil {
		return dto.NotificationPageResponse{}, err
	}

	// Step 3: Fetch senders
	senderIDs := make([]uint, 0, len(notifications))
	for _, n := range notifications {
		if *n.SenderID != 0 {
			senderIDs = append(senderIDs, *n.SenderID)
		}
	}

	senders, err := service.Repo.FindUsersByIDs(senderIDs)
	if err != nil {
		return dto.NotificationPageResponse{}, err
	}

	// Step 4: Assemble DTOs
	senderMap := make(map[uint]domain.User)
	for _, sender := range senders {
		senderMap[sender.UserID] = sender
	}

	var dtos []dto.NotificationInstance
	for _, n := range notifications {
		readStatus := getReadStatus(n.NotificationID, notificationRecipients)
		senderName := "System"
		senderRole := "SYSTEM"
		if sender, ok := senderMap[*n.SenderID]; ok {
			senderName = sender.Username
			senderRole = sender.UserRole
		}
		buffer := dto.NotificationInstance{
			NotificationID: n.NotificationID,
			Title:          n.Title,
			Content:        n.Content,
			CreatedAt:      n.CreatedAt,
			ReadStatus:     readStatus,
			SenderName:     senderName,
			SenderRole:     senderRole,
		}
		dtos = append(dtos, buffer)
	}

	total := service.Repo.CountNotificationsByRecipientID(recipientID)

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

func (service *NotificationService) InsertNotificationBySystem(title, content string, recipientId uint) error {
	return service.Repo.InsertNotificationBySystem(title, content, recipientId)
}

func getReadStatus(notificationID uint, notificationRecipients []domain.NotificationRecipient) bool {
	for _, nr := range notificationRecipients {
		if nr.NotificationID == notificationID {
			return nr.ReadStatus
		}
	}
	return false
}
