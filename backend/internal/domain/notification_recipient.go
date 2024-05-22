package domain

// NotificationRecipient tb_notification_recipient 表示通知和接收者之间的关系
type NotificationRecipient struct {
	NotificationID uint `gorm:"primary_key;column:notification_id"`
	RecipientID    uint `gorm:"primary_key;column:recipient_id"`
	ReadStatus     bool `gorm:"column:read_status;default:false"` // 默认为未读
}
