package validate_account_type

import "github.com/go-playground/validator/v10"

func ValidateAccountType(fl validator.FieldLevel) bool {
	accountType := fl.Field().String()
	return accountType == "ADMIN" || accountType == "MEMBER"
}
