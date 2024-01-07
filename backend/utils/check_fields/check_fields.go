package check_fields

import (
	"reflect"
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
	return reflect.DeepEqual(v, reflect.Zero(reflect.TypeOf(v)).Interface())
}
