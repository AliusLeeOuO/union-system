package dto

type Pagination struct {
	PageSize uint `json:"page_size" form:"page_size" validate:"required"`
	PageNum  uint `json:"page_num" form:"page_num" validate:"required"`
}

type PageResponse struct {
	PageSize uint `json:"page_size"`
	PageNum  uint `json:"page_num"`
	Total    uint `json:"total"`
}
