package check_fields

import "strings"

// CheckFields 检查提供的字符串字段是否为空
// 如果发现空字段，返回 false 和拼接的字段名字符串
func CheckFields(fields map[string]string) (bool, string) {
	var missingFields []string

	for fieldName, fieldValue := range fields {
		if fieldValue == "" {
			missingFields = append(missingFields, fieldName)
		}
	}

	// 如果有缺失的字段，拼接它们并返回
	if len(missingFields) > 0 {
		return false, strings.Join(missingFields, ", ")
	}

	return true, ""
}
