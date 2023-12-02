package captcha

import (
	"github.com/mojocn/base64Captcha"
	"strings"
	"union-system/internal/dto"
)

var store = base64Captcha.DefaultMemStore

func CreateCaptcha() (*dto.CaptchaResponse, error) {
	var driverString base64Captcha.DriverString
	driverString.Source = "1234567890QWERTYUPLKJHGFDSAZXCVBNMqwertyupkjhgfdsazxcvbnm"
	driverString.Width = 120
	driverString.Height = 50
	driverString.NoiseCount = 0
	driverString.Length = 4
	driverString.Fonts = []string{"RitaSmith.ttf", "actionj.ttf", "chromohv.ttf"}
	driver := driverString.ConvertFonts()
	c := base64Captcha.NewCaptcha(driver, store)
	id, b64s, err := c.Generate()
	if err != nil {
		return nil, err
	}
	return &dto.CaptchaResponse{
		CaptchaID: id,
		ImagePath: b64s,
	}, nil
}

func VerifyCode(codeID string, code string) bool {
	if codeID == "" {
		return false
	}
	vv := store.Get(codeID, true)
	vv = strings.TrimSpace(vv)
	code = strings.TrimSpace(code)
	if strings.EqualFold(vv, code) {
		return true
	}
	return false
}
