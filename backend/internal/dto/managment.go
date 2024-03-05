package dto

type CreateUserRequest struct {
	Username string `json:"username" form:"username"`
	Password string `json:"password" form:"password"`
	Email    string `json:"email" form:"email"`
	Role     uint   `json:"role" form:"role"`
	Phone    uint   `json:"phone" form:"phone"`
}
