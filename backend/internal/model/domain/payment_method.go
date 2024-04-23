package domain

// PaymentMethod tb_payment_method
type PaymentMethod struct {
	MethodID uint   `gorm:"primaryKey;column:method_id;autoIncrement"`
	Name     string `gorm:"column:name;size:255;not null"`
}
