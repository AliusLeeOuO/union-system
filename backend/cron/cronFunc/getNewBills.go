package cronFunc

import (
	"fmt"
	"time"
	"union-system/global"
	"union-system/internal/repository"
	"union-system/internal/service"
)

func GetNewBills() {

	feeService := service.NewFeeService(repository.NewFeeRepository(global.Database))

	if err := feeService.GenerateMonthlyFeeBills(time.Now().Format("200601")); err != nil {
		// 记录错误
		fmt.Println("生成月度会费账单失败:", err)
	}
}
