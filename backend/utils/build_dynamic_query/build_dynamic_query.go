package build_dynamic_query

import (
	"gorm.io/gorm"
	"reflect"
)

func BuildDynamicQuery(db *gorm.DB, tableName string, conditions map[string]interface{}) *gorm.DB {
	query := db.Table(tableName)

	// 添加条件
	for key, value := range conditions {
		// 使用反射检查零值
		if reflect.ValueOf(value).IsZero() {
			continue
		}

		// 对于字符串，检查是否为空字符串
		if strVal, ok := value.(string); ok && strVal == "" {
			continue
		}

		// 对于数字，检查是否为零
		if numVal, ok := value.(uint); ok && numVal == 0 {
			continue
		}

		// 添加条件
		query = query.Where(key+" = ?", value)
	}

	return query
}
