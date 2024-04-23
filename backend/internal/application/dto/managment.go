package dto

type CreateUserRequest struct {
	Username string `json:"username" form:"username" validate:"required"`
	Password string `json:"password" form:"password" validate:"required"`
	Email    string `json:"email" form:"email" validate:"required"`
	Role     uint   `json:"role" form:"role" validate:"required"`
	Phone    uint   `json:"phone" form:"phone" validate:"required"`
}

type UpdateUserRequest struct {
	UserId   uint    `json:"user_id" form:"user_id" validate:"required"`
	Username string  `json:"username" form:"username" validate:"required"`
	Email    string  `json:"email" form:"email" validate:"required"`
	Phone    string  `json:"phone_number" form:"phone" validate:"required"`
	Status   bool    `json:"is_active" form:"status" validate:"required"`
	Password *string `json:"password,omitempty" form:"password"` // 使用指针以便区分未传递和空字符串
}

type CPUInfo struct {
	Cores  uint    `json:"cores"`
	Trends uint    `json:"trends"`
	Model  string  `json:"models"`
	Cache  uint    `json:"cache"`
	Usage  float64 `json:"usage"`
	Idle   float64 `json:"idle"`
}

type MemoryInfo struct {
	Total uint    `json:"total"`
	Used  uint    `json:"used"`
	Free  uint    `json:"free"`
	Usage float64 `json:"usage"`
}

type WebsocketPingResponse struct {
	Code    int    `json:"code"`
	Channel string `json:"channel"`
	Msg     string `json:"message"`
}

type WebsocketCpuInfoResponse struct {
	Code    int     `json:"code"`
	Channel string  `json:"channel"`
	Msg     CPUInfo `json:"message"`
}

type WebsocketMemInfoResponse struct {
	Code    int        `json:"code"`
	Channel string     `json:"channel"`
	Msg     MemoryInfo `json:"message"`
}

// WebsocketMessageRequest 定义了WebSocket消息请求的结构体
type WebsocketMessageRequest struct {
	Action  string `json:"action"`  // 操作类型，例如 "subscribe" 或 "unsubscribe"
	Channel string `json:"channel"` // 频道名称，例如 "cpuInfo" 等
}
