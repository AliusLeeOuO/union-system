package dto

type CaptchaResponse struct {
	CaptchaID string `json:"captchaID"`
	ImagePath string `json:"imagePath"`
}

type LoginResponse struct {
	UserId   uint   `json:"user_id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   uint   `json:"status"`
	Token    string `json:"token"`
}

// LoginRequest 定义了登录请求的数据结构
type LoginRequest struct {
	Username   string `json:"username" form:"username"`
	Password   string `json:"password" form:"password"`
	CaptchaID  string `json:"captcha_id" form:"captcha_id"`
	CaptchaVal string `json:"captcha_val" form:"captcha_val"`
}

// ChangePasswordRequest 定义了修改密码请求的数据结构
type ChangePasswordRequest struct {
	OldPassword string `json:"old_password" form:"old_password"`
	NewPassword string `json:"new_password" form:"new_password"`
}
