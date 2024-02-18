package captcha

import (
	"github.com/mojocn/base64Captcha" // 导入 base64Captcha 包，用于生成和验证 base64 编码的图像验证码。
	"strings"
	"union-system/internal/dto" // 导入内部 dto 包，可能用于定义数据传输对象。
)

// store 是用于存储验证码信息的内存存储对象。
var store = base64Captcha.DefaultMemStore

// CreateCaptcha 用于生成新的图像验证码。
func CreateCaptcha() (*dto.CaptchaResponse, error) {
	var driverString base64Captcha.DriverString // 创建一个 DriverString 结构体实例，用于配置验证码的参数。

	// 设置验证码字符源，这里包含数字和大小写字母。
	driverString.Source = "1234567890QWERTYUPLKJHGFDSAZXCVBNMqwertyupkjhgfdsazxcvbnm"
	driverString.Width = 120                                                      // 设置验证码图片的宽度。
	driverString.Height = 50                                                      // 设置验证码图片的高度。
	driverString.NoiseCount = 0                                                   // 设置验证码噪点数量，这里设置为 0。
	driverString.Length = 4                                                       // 设置验证码的长度，这里设置为 4 个字符。
	driverString.Fonts = []string{"RitaSmith.ttf", "actionj.ttf", "chromohv.ttf"} // 设置验证码的字体。

	driver := driverString.ConvertFonts()        // 将配置的字体转换为 DriverString 可用的格式。
	c := base64Captcha.NewCaptcha(driver, store) // 创建一个新的 base64Captcha 实例。
	id, b64s, _, err := c.Generate()             // 生成验证码，返回验证码ID、base64编码的图片和可能的错误。
	if err != nil {
		return nil, err // 如果有错误发生，则返回错误。
	}

	// 返回一个包含验证码ID和图像路径的 CaptchaResponse 实例。
	return &dto.CaptchaResponse{
		CaptchaID: id,
		ImagePath: b64s,
	}, nil
}

// VerifyCode 用于验证用户输入的验证码是否正确。
func VerifyCode(codeID string, code string) bool {
	if codeID == "" {
		return false // 如果验证码 ID 为空，则直接返回 false。
	}

	vv := store.Get(codeID, true)  // 从 store 中获取对应 ID 的验证码值。
	vv = strings.TrimSpace(vv)     // 清除验证码值两端的空白字符。
	code = strings.TrimSpace(code) // 清除用户输入验证码两端的空白字符。

	// 使用 strings.EqualFold 进行不区分大小写的比较，如果相等，则返回 true。
	if strings.EqualFold(vv, code) {
		return true
	}
	return false
}
