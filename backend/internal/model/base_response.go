package model

import (
	"github.com/gofiber/fiber/v2"
)

type BaseResponse struct {
	RespError
	Data interface{} `json:"data,omitempty"`
}

type RespError struct {
	Code    int    `json:"code"`
	Message string `json:"message,omitempty"`
}

const (
	SuccessCode          = 0
	AuthFailedCode       = 1000
	QueryParamErrorCode  = 1400
	ResourceNotFoundCode = 1405
	SystemErrorCode      = 1500
	CaptchaErrorCode     = 2003
)

var respErrorMessages = map[int]string{
	SuccessCode:          "Success",
	QueryParamErrorCode:  "请求参数有误",
	AuthFailedCode:       "令牌无效",
	ResourceNotFoundCode: "访问资源不存在",
	SystemErrorCode:      "服务内部错误",
	CaptchaErrorCode:     "验证码错误",
}

func getErrorMessage(code int) string {
	msg, ok := respErrorMessages[code]
	if !ok {
		return "未知错误"
	}
	return msg
}

// SendSuccessResponse 发送一个成功的响应
func SendSuccessResponse(c *fiber.Ctx, data interface{}) error {
	response := BaseResponse{
		RespError: RespError{Code: SuccessCode, Message: getErrorMessage(SuccessCode)},
		Data:      data,
	}
	return c.JSON(response)
}

// SendFailureResponse 发送一个失败的响应
func SendFailureResponse(c *fiber.Ctx, code int) error {
	response := BaseResponse{
		RespError: RespError{Code: code, Message: getErrorMessage(code)},
	}
	return c.Status(fiber.StatusBadRequest).JSON(response)
}
