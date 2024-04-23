package domain

// MemberCategory tb_member_category
type MemberCategory struct {
	CategoryID uint   `gorm:"primaryKey;column:category_id;autoIncrement"`
	Name       string `gorm:"column:name;size:255;not null"`
}
