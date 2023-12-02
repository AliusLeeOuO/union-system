package dto

type CaptchaResponse struct {
	CaptchaID string `json:"captchaID"`
	ImagePath string `json:"imagePath"`
}

// LoginRequest 定义了登录请求的数据结构
type LoginRequest struct {
	Username   string `json:"username" form:"username"`
	Password   string `json:"password" form:"password"`
	CaptchaID  string `json:"captcha_id" form:"captcha_id"`
	CaptchaVal string `json:"captcha_val" form:"captcha_val"`
}
