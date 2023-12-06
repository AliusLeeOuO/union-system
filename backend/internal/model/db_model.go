package model

type TbUser struct {
	//gorm.Model
	ID       uint   `gorm:"primaryKey;autoIncrement;column:id"`
	Username string `gorm:"type:varchar(50);not null;column:username"`
	Password string `gorm:"type:varchar(60);not null;column:password"`
	Role     uint   `gorm:"type:int unsigned;not null;column:role"`
	Status   uint   `gorm:"type:int unsigned;not null;column:status"`
}
