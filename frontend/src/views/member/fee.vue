<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{route, paths}">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <a-typography-title :heading="2">
    会费
  </a-typography-title>
  <div class="description-title">
    我的会费标准
  </div>
  <div class="fee-overview grid grid-cols-3 p-4">
    <div class="text-center">
      <a-statistic title="我的会费" :value="currentFeeInfo.amount" :value-from="0" animation :precision="2" />
    </div>
    <div class="text-center">
      <a-statistic title="未交金额" :value="calculateUnpaidFee" :value-from="0" animation :precision="2" />
    </div>
    <div class="text-center">
      <a-statistic title="上次交费日期" :value="undefined" :placeholder="lastFeeDate" />
    </div>
  </div>
  <div class="description-title">
    查看会费记录
  </div>
  <a-empty v-if="feeHistoryData.length === 0" />
  <a-table
    v-else
    :columns="feeHistoryColumns"
    :data="feeHistoryData"
    size="large"
    @page-change="feeHistoryChangePage"
    :pagination="{
        total: feeHistoryPagination.total,
        pageSize: feeHistoryPagination.pageSize
      }">
    <template #created_at="{ record }">
      {{ dayjs.tz(record.created_at).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
  </a-table>
  <div class="description-title">
    等待缴费项目
  </div>
  <a-empty v-if="waitingFeeData.length === 0" />
  <a-table
    v-else
    :columns="waitingFeeColumns"
    :data="waitingFeeData"
    size="large"
    @page-change="waitingFeeChangePage"
    :pagination="{
        total: waitingFeePagination.total,
        pageSize: waitingFeePagination.pageSize,
      }">
    <template #created_at="{ record }">
      {{ dayjs.tz(record.created_at).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
    <template #action="{ record }">
      <a-button>缴费</a-button>
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { reactive, onMounted, computed } from "vue"
import useMemberApi, { type feeHistoryResponse } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { type BreadcrumbRoute, Message } from "@arco-design/web-vue"
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

const memberApi = useMemberApi()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const routes: BreadcrumbRoute[] = [
  {
    path: "/member/fee",
    label: "会费"
  }
]



const currentFeeInfo = reactive({
  amount: 0,
  standard_id: 0,
  category_id: 0
})

const fetchFeeInfo = async () => {
  const { data } = await handleXhrResponse(() => memberApi.feeStandard(), Message)
  currentFeeInfo.amount = data.data.amount
  currentFeeInfo.standard_id = data.data.standard_id
  currentFeeInfo.category_id = data.data.category_id
}

const feeHistoryColumns = [
  {
    title: "账单ID",
    dataIndex: "bill_id"
  },
  {
    title: "缴费金额",
    dataIndex: "amount"
  },
  {
    title: "账单创建时间",
    slotName: "created_at"
  },
  {
    title: "交费标记",
    dataIndex: "fee_period"
  }
]
const feeHistoryData = reactive<feeHistoryResponse[]>([])
const feeHistoryPagination = reactive({
  total: 0,
  pageSize: 10,
  current: 1
})
const feeHistoryChangePage = async (page: number) => {
  feeHistoryPagination.current = page
  await fetchFeeHistory()
}
const fetchFeeHistory = async () => {
  const { data } = await handleXhrResponse(() => memberApi.feeHistory(feeHistoryPagination.pageSize, feeHistoryPagination.current), Message)
  feeHistoryData.splice(0, feeHistoryData.length)
  if (data.data.history !== null) {
    feeHistoryData.push(...data.data.history)
  } else {
    feeHistoryData.push()
  }
  feeHistoryPagination.total = data.data.total
}

const waitingFeeColumns = [
  {
    title: "账单ID",
    dataIndex: "bill_id"
  },
  {
    title: "缴费金额",
    dataIndex: "amount"
  },
  {
    title: "账单创建时间",
    slotName: "created_at"
  },
  {
    title: "交费标记",
    dataIndex: "fee_period"
  },
  {
    title: "操作",
    slotName: "action"
  }
]

const waitingFeeData = reactive<feeHistoryResponse[]>([])

const waitingFeePagination = reactive({
  total: 0,
  pageSize: 10,
  current: 1
})

const waitingFeeChangePage = async (page: number) => {
  feeHistoryPagination.current = page
  await fetchWaitingFee()
}

const fetchWaitingFee = async () => {
  const { data } = await handleXhrResponse(() => memberApi.waitingFeeList(waitingFeePagination.pageSize, waitingFeePagination.current), Message)
  waitingFeeData.splice(0, waitingFeeData.length)
  if (data.data.bills !== null) {
    waitingFeeData.push(...data.data.bills)
    waitingFeePagination.total = data.data.bills.length
    waitingFeePagination.pageSize = data.data.bills.length
  } else {
    waitingFeeData.push()
  }
}

// 计算非缴费的会费
const calculateUnpaidFee = computed(() => {
  let c = 0
  waitingFeeData.forEach((item) => {
    c += item.amount
  })
  return c
})

// 计算上次交费日期
const lastFeeDate = computed(() => {
  let lastDate = ""
  feeHistoryData.forEach((item) => {
    if (item.payment_status === true) {
      lastDate = item.created_at
    }
  })
  if (lastDate === "") {
    return "无"
  }
  return dayjs.tz(lastDate).format("YYYY-MM-DD")
})


onMounted(async () => {
  await fetchFeeInfo()
  await fetchFeeHistory()
  await fetchWaitingFee()
})
</script>
<style scoped lang="less">
.description-title {
  margin-top: 10px;
  font-size: 16px;
  padding-bottom: 20px;

  &::before {
    content: "";
    display: inline-block;
    width: 8px; /* 方块的宽度 */
    height: 18px; /* 方块的高度 */
    background-color: rgb(var(--primary-6)); /* 方块的颜色 */
    margin-right: 8px; /* 和文本之间的距离 */
    vertical-align: middle;
  }
}

.fee-overview {
  grid-gap: 5px;

  .fee-overview-block {

    .fee-overview-title {
      font-size: 12px;
    }

    .fee-overview-content {
      font-size: 20px;
      margin-top: 10px;
    }
  }
}
</style>
