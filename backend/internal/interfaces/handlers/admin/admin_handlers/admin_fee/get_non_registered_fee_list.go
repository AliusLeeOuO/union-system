package admin_fee

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
	"union-system/internal/interfaces/models"
)

type feeNonRegListRequest struct {
	dto.Pagination
}

func GetNonRegisteredFeeList(c *fiber.Ctx) error {
	var validate = validator.New()
	var form feeNonRegListRequest
	if err := c.BodyParser(&form); err != nil || validate.Struct(form) != nil {
		return models.SendFailureResponse(c, models.QueryParamErrorCode)
	}
	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))
	feeList, total, err := feeService.GetNonRegisteredUsers(form.PageSize, form.PageNum)
	if err != nil {
		return models.SendFailureResponse(c, models.InternalServerErrorCode, err.Error())
	}

	var res []dto.UserNonFee

	for _, user := range feeList {
		res = append(res, dto.UserNonFee{
			UserID:      user.UserID,
			Username:    user.Username,
			Email:       user.Email,
			PhoneNumber: user.PhoneNumber,
			RegisterAt:  user.RegistrationDate.Format(time.RFC3339),
		})
	}

	return models.SendSuccessResponse(c, &dto.UserNonFeeResponse{
		PageResponse: dto.PageResponse{
			Total:    total,
			PageSize: form.PageSize,
			PageNum:  form.PageNum,
		},
		Users: res,
	})
}
