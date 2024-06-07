package domain

type RolePermission struct {
	RoleId       uint `gorm:"primary_key;column:role_id"`
	PermissionId uint `gorm:"primary_key;column:permission_id"`
}
