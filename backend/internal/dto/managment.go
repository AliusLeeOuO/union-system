package dto

type CreateUserRequest struct {
	Username string `json:"username" form:"username"`
	Password string `json:"password" form:"password"`
	Email    string `json:"email" form:"email"`
	Role     uint   `json:"role" form:"role"`
	Phone    uint   `json:"phone" form:"phone"`
}

type UpdateUserRequest struct {
	UserId   uint    `json:"user_id" form:"user_id"`
	Username string  `json:"username" form:"username"`
	Email    string  `json:"email" form:"email"`
	Phone    string  `json:"phone_number" form:"phone"`
	Status   bool    `json:"is_active" form:"status"`
	Password *string `json:"password,omitempty" form:"password"` // 使用指针以便区分未传递和空字符串
}

type CPUInfo struct {
	Cores  uint    `json:"cores"`
	Trends uint    `json:"trends"`
	Model  string  `json:"model"`
	Cache  uint    `json:"cache"`
	Usage  float64 `json:"usage"`
	Idle   float64 `json:"idle"`
}

type MemoryInfo struct {
	Total uint    `json:"total`
	Used  uint    `json:"used"`
	Free  uint    `json:"free"`
	Usage float64 `json:"usage"`
}
