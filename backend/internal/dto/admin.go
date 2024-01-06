package dto

type Pagination struct {
	PageSize uint `json:"page_size" form:"page_size"`
	PageNum  uint `json:"page_num" form:"page_num"`
}

// GetUserListRequest 定义了获取管理员用户列表请求的数据结构
type GetUserListRequest struct {
	Pagination
	// 根据ID查询，可选
	ID uint `json:"id" form:"id"`
	// 根据用户名查询，可选
	Username string `json:"username" form:"username"`
	// 根据角色查询，可选
	Role uint `json:"role" form:"role"`
}

// GetAssistanceTypeRequest 定义了获取援助类型列表请求的数据结构
type GetAssistanceTypeRequest struct {
	AssistanceTypeId uint   `json:"assistance_type_id" form:"assistance_type_id"`
	TypeName         string `json:"type_name" form:"type_name"`
}

type GetAdminUserListResponse struct {
	Data     []GetAdminUserResponse `json:"data"`
	Page     uint                   `json:"page"`
	PageSize uint                   `json:"page_size"`
}

type GetAdminUserResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   bool   `json:"status"`
}
