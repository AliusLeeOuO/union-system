package dto

import "time"

type CaptchaResponse struct {
	CaptchaID string `json:"captchaID"`
	ImagePath string `json:"imagePath"`
}

type LoginResponse struct {
	UserId   uint   `json:"user_id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   bool   `json:"status"`
	Token    string `json:"token"`
}

// UploadFileResponse 定义了上传文件响应的数据结构
type UploadFileResponse struct {
	FileName string `json:"file_name"`
	FileURL  string `json:"file_url"`
}

// LoginRequest 定义了登录请求的数据结构
type LoginRequest struct {
	Username   string `json:"username" form:"username" validate:"required"`
	Password   string `json:"password" form:"password" validate:"required"`
	CaptchaID  string `json:"captcha_id" form:"captcha_id" validate:"required"`
	CaptchaVal string `json:"captcha_val" form:"captcha_val" validate:"required"`
}

// ChangePasswordRequest 定义了修改密码请求的数据结构
type ChangePasswordRequest struct {
	OldPassword string `json:"old_password" form:"old_password" validate:"required"`
	NewPassword string `json:"new_password" form:"new_password" validate:"required"`
}

// UserInfoResponse 定义了获取用户信息响应的数据结构
type UserInfoResponse struct {
	UserID   uint   `json:"user_id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   bool   `json:"status"`
	Phone    string `json:"phone"`
	Email    string `json:"email"`
}
type UserQueryRequest struct {
	UserID uint `form:"user_id" validate:"required"`
}

type UserRegisterRequest struct {
	Username       string `json:"username" form:"username" validate:"required"`
	Password       string `json:"password" form:"password" validate:"required"`
	Email          string `json:"email" form:"email" validate:"required"`
	PhoneNumber    uint   `json:"phone_number" form:"phone_number" validate:"required"`
	InvitationCode string `json:"invitation_code" form:"invitation_code" validate:"required"`
}

type InvitationCodeListResponse struct {
	PageResponse
	Data []InvitationCodeResponse `json:"data"`
}

type InvitationCodeResponse struct {
	CodeID          uint      `json:"code_id"`
	Code            string    `json:"code"`
	CreatedByUserID uint      `json:"created_by_user_id"`
	UsedByUserID    string    `json:"used_by_user_id"`
	IsUsed          bool      `json:"is_used"`
	CreatedAt       time.Time `json:"created_at"`
	ExpiresAt       time.Time `json:"expires_at"`
}

type NewInvitationCodeResponse struct {
	CodeID    uint   `json:"code_id"`
	Code      string `json:"code"`
	CreatedAt string `json:"created_at"`
	ExpiresAt string `json:"expires_at"`
}
