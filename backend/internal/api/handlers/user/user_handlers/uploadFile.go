package user_handlers

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"math/rand"
	"mime/multipart"
	"strings"
	"time"
	"union-system/internal/dto"
	"union-system/internal/model"
)

func UploadHandler(c *fiber.Ctx) error {
	file, err := c.FormFile("file")
	if err != nil {
		return err
	}

	// 检查文件类型
	if !isValidFileType(file) {
		return model.SendFailureResponse(c, model.InvalidFileTypeErrorCode)
	}

	// 生成随机文件名
	randomNumber := rand.Intn(1000000)
	timestamp := fmt.Sprintf("%v", time.Now().Unix())
	newFileName := fmt.Sprintf("%s_%d_%s", timestamp, randomNumber, file.Filename)

	// 保存文件
	err = c.SaveFile(file, "./uploads/"+newFileName)
	if err != nil {
		return err
	}

	return model.SendSuccessResponse(c, dto.UploadFileResponse{
		FileName: newFileName,
		FileURL:  "/uploads/" + newFileName,
	})
}

func isValidFileType(file *multipart.FileHeader) bool {
	// 添加你希望接受的文件类型
	allowedTypes := []string{
		"image/jpeg", "image/png", "image/gif",
		"application/pdf",
		"application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // DOC & DOCX
		"application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", // XLS & XLSX
		"application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation", // PPT & PPTX
	}

	for _, t := range allowedTypes {
		if strings.Contains(file.Header.Get("Content-Type"), t) {
			return true
		}
	}
	return false
}
