package repository

import (
	"gorm.io/gorm"
	"union-system/internal/application/dto"
	"union-system/internal/domain"
)

type NotificationRepository struct {
	DB *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) *NotificationRepository {
	return &NotificationRepository{DB: db}
}

func (repo *NotificationRepository) FindNotificationsByRecipientID(recipientID uint, pageSize uint, pageNum uint) ([]dto.NotificationWithReadStatus, uint, error) {
	var results []dto.NotificationWithReadStatus

	offset := (pageNum - 1) * pageSize
	subQuery := repo.DB.
		Model(&domain.NotificationRecipient{}).
		Where("recipient_id = ?", recipientID).
		Select("notification_id, read_status")

	result := repo.DB.
		Model(&domain.Notification{}).
		Select("tb_notification.*, nr.read_status, u.username AS sender_name, u.user_role AS sender_role").
		Joins("JOIN (?) AS nr ON tb_notification.notification_id = nr.notification_id", subQuery).
		Joins("JOIN tb_user AS u ON tb_notification.sender_id = u.user_id"). // 修改这里
		Limit(int(pageSize)).
		Offset(int(offset)).
		Scan(&results)

	if result.Error != nil {
		return nil, 0, result.Error
	}

	var total int64
	repo.DB.Model(&domain.NotificationRecipient{}).Where("recipient_id = ?", recipientID).Count(&total)

	return results, uint(total), nil
}

func (repo *NotificationRepository) MarkNotificationAsRead(notificationID uint, recipientID uint) error {
	result := repo.DB.Model(&domain.NotificationRecipient{}).
		Where("notification_id = ? AND recipient_id = ?", notificationID, recipientID).
		Update("read_status", true)
	return result.Error
}

func (repo *NotificationRepository) MarkAllNotificationsAsRead(recipientID uint) error {
	result := repo.DB.Model(&domain.NotificationRecipient{}).
		Where("recipient_id = ?", recipientID).
		Update("read_status", true)
	return result.Error
}

func (repo *NotificationRepository) CountUnreadNotifications(recipientID uint) (uint, error) {
	var count int64
	result := repo.DB.Model(&domain.NotificationRecipient{}).
		Where("recipient_id = ? AND read_status = ?", recipientID, false).
		Count(&count)
	if result.Error != nil {
		return 0, result.Error
	}
	return uint(count), nil
}

func (repo *NotificationRepository) InsertNotificationBySystem(title, content string, recipientId uint) error {
	notificationModel := domain.Notification{
		Title:   title,
		Content: content,
	}

	result := repo.DB.Omit("sender_id").Create(&notificationModel)
	if result.Error != nil {
		return result.Error
	}

	recipientModel := domain.NotificationRecipient{
		NotificationID: notificationModel.NotificationID,
		RecipientID:    recipientId,
		ReadStatus:     false,
	}

	result = repo.DB.Create(&recipientModel)
	return result.Error
}

func (repo *NotificationRepository) FindNotificationRecipientsByRecipientID(recipientID uint, pageSize uint, pageNum uint) ([]domain.NotificationRecipient, error) {
	var results []domain.NotificationRecipient

	offset := (pageNum - 1) * pageSize
	result := repo.DB.
		Where("recipient_id = ?", recipientID).
		Limit(int(pageSize)).
		Offset(int(offset)).
		Find(&results)

	if result.Error != nil {
		return nil, result.Error
	}

	return results, nil
}

func (repo *NotificationRepository) FindNotificationsByIDs(notificationIDs []uint) ([]domain.Notification, error) {
	var results []domain.Notification

	result := repo.DB.
		Where("notification_id IN (?)", notificationIDs).
		// 按照创建时间降序排序
		Order("created_at DESC").
		Find(&results)

	if result.Error != nil {
		return nil, result.Error
	}

	return results, nil
}

func (repo *NotificationRepository) FindUsersByIDs(userIDs []uint) ([]domain.User, error) {
	var results []domain.User

	result := repo.DB.
		Where("user_id IN (?)", userIDs).
		Find(&results)

	if result.Error != nil {
		return nil, result.Error
	}

	return results, nil
}

func (repo *NotificationRepository) CountNotificationsByRecipientID(recipientID uint) uint {
	var total int64
	repo.DB.Model(&domain.NotificationRecipient{}).Where("recipient_id = ?", recipientID).Count(&total)
	return uint(total)
}
