package domain

import "time"

// Permission tb_permission
type Permission struct {
	PermissionID       uint      `gorm:"primary_key;column:permission_id;autoIncrement" json:"permission_id,omitempty"`
	PermissionName     string    `gorm:"column:permission_name;size:255;not null" json:"permission_name,omitempty"`
	Description        string    `gorm:"column:description;size:255" json:"description,omitempty"`
	RoleType           string    `gorm:"column:role_type;size:1" json:"role_type,omitempty"`
	ParentPermissionID uint      `gorm:"column:parent_permission_id" json:"parent_permission_id,omitempty"`
	PermissionNode     string    `gorm:"column:permission_node;size:100" json:"permission_node,omitempty"`
	Icon               string    `gorm:"column:icon;size:30" json:"icon,omitempty"`
	GmtCreate          time.Time `gorm:"column:gmt_create" json:"gmt_create"`
	DelFlag            bool      `gorm:"column:del_flag" json:"del_flag,omitempty"`
}
