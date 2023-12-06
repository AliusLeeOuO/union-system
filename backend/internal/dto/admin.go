package dto

type Pagination struct {
	PageSize uint `json:"page_size" form:"page_size"`
	PageNum  uint `json:"page_num" form:"page_num"`
}

// GetAdminUserListRequest 定义了获取管理员用户列表请求的数据结构
type GetAdminUserListRequest struct {
	Pagination
	// 根据ID查询，可选
	ID uint `json:"id" form:"id"`
	// 根据用户名查询，可选
	Username string `json:"username" form:"username"`
}

type GetAdminUserListResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   uint   `json:"status"`
}
