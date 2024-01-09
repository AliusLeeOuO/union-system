package dto

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

// GetAssistanceListRequest 定义了获取援助列表请求的数据结构
type GetAssistanceListRequest struct {
	Pagination
	// 根据ID查询，可选
	ID uint `json:"id" form:"id"`
	// 根据援助类型查询，可选
	AssistanceTypeId uint `json:"assistance_type_id" form:"assistance_type_id"`
}

// GetAssistanceListResponse 定义了获取援助列表响应的数据结构
type GetAssistanceListResponse struct {
	PageResponse
	Data []GetAssistanceResponse `json:"data"`
}

// GetAssistanceResponse 定义了获取援助响应的数据结构
type GetAssistanceResponse struct {
	ID uint `json:"id"`
	// 将 AssistanceType 修改为嵌套结构体
	AssistanceType AssistanceTypeResponse `json:"assistance_type"`
	Title          string                 `json:"title"`
	Status         uint                   `json:"status"`
}

// AssistanceTypeResponse 定义了援助类型的响应结构
type AssistanceTypeResponse struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
}

type GetAdminUserListResponse struct {
	PageResponse
	Data []GetAdminUserResponse `json:"data"`
}

type GetAdminUserResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Role     uint   `json:"role"`
	Status   bool   `json:"status"`
}
