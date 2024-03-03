package repository

import (
	"gorm.io/gorm"
	"union-system/internal/model"
)

type NotificationRepository struct {
	DB *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) *NotificationRepository {
	return &NotificationRepository{DB: db}
}

func (repo *NotificationRepository) FindNotificationsByRecipientID(recipientID uint, pageSize uint, pageNum uint) ([]model.Notification, uint, error) {
	var notifications []model.Notification
	var total int64

	offset := (pageNum - 1) * pageSize
	// 使用子查询来筛选特定接收者的通知
	subQuery := repo.DB.
		Model(&model.NotificationRecipient{}).
		Select("notification_id").
		Where("recipient_id = ?", recipientID)

	result := repo.DB.
		Joins("JOIN (?) AS nr ON nr.notification_id = tb_notification.notification_id", subQuery).
		Limit(int(pageSize)).
		Offset(int(offset)).
		Find(&notifications)

	if result.Error != nil {
		return nil, 0, result.Error
	}

	// 应用相同的筛选条件来计算总数
	repo.DB.
		Model(&model.Notification{}).
		Joins("JOIN (?) AS nr ON nr.notification_id = tb_notification.notification_id", subQuery).
		Count(&total)

	return notifications, uint(total), nil
}
