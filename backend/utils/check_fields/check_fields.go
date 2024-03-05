package check_fields

import (
	"reflect"
	"regexp"
	"strconv"
	"strings"
)

// CheckFields 检查提供的字段是否为空（对于字符串）或为零（对于数字），除非指定为可跳过
// skipZeroCheck 字段列表指定哪些数字字段可以为零
func CheckFields(fields map[string]interface{}, skipZeroCheck []string) (bool, string) {
	var missingFields []string
	skipCheckMap := make(map[string]bool)

	for _, fieldName := range skipZeroCheck {
		skipCheckMap[fieldName] = true
	}

	for fieldName, fieldValue := range fields {
		// 对于字符串，检查是否为空
		if value, ok := fieldValue.(string); ok {
			if value == "" {
				missingFields = append(missingFields, fieldName)
			}
		} else if _, skip := skipCheckMap[fieldName]; !skip {
			// 对于数字，检查是否为零，除非在跳过列表中
			if isZero(fieldValue) {
				missingFields = append(missingFields, fieldName)
			}
		}
	}

	if len(missingFields) > 0 {
		return false, strings.Join(missingFields, ", ")
	}

	return true, ""
}

// CheckFieldsWithDefaults 仅接受必要参数，使用默认的零值检查跳过规则
func CheckFieldsWithDefaults(fields map[string]interface{}) (bool, string) {
	return CheckFields(fields, []string{}) // 假设默认情况下不跳过任何字段
}

// isZero 检查给定值是否为其类型的零值
func isZero(v interface{}) bool {
	// 特殊处理布尔类型：false 不被视为零值
	if _, ok := v.(bool); ok {
		return false // 布尔值总是被认为是非零的
	}

	// 对于其他类型，使用 reflect.DeepEqual 检查零值
	return reflect.DeepEqual(v, reflect.Zero(reflect.TypeOf(v)).Interface())
}

// ValidateEmail 函数接收一个字符串参数并返回一个布尔值
// 如果输入的字符串符合邮箱格式，返回 true；否则返回 false
func ValidateEmail(email string) bool {
	// 定义一个邮箱的正则表达式
	var emailRegex = regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)
	return emailRegex.MatchString(email)
}

// ValidateMobile 函数接收一个 uint 参数并返回一个布尔值
// 如果输入的 uint 符合中国大陆手机号格式，返回 true；否则返回 false
func ValidateMobile(mobile uint) bool {
	// 将 uint 类型的手机号转换为字符串
	mobileStr := strconv.FormatUint(uint64(mobile), 10)
	// 定义一个中国大陆手机号的正则表达式
	var mobileRegex = regexp.MustCompile(`^1[3-9]\d{9}$`)
	return mobileRegex.MatchString(mobileStr)
}
