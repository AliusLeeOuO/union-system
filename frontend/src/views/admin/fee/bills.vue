<template>
  <a-card class="mb-4">
    <div class="flex justify-between">
      <a-space class="flex-1">
        <a-alert>账单将由系统在月初自动定时生成，无需手动生成。</a-alert>
      </a-space>
      <a-space>
        <a-button @click="fetchBills">
          <template #icon>
            <IconRefresh />
          </template>
          刷新
        </a-button>
      </a-space>
    </div>
  </a-card>
  <a-card>
    <a-table
      :columns="columns"
      :data="tableData"
      :pagination="{
        current: pageInfo.pageNum,
        pageSize: pageInfo.pageSize,
        total: pageInfo.total,
      }"
      :loading="fetchBillLoading"
      @page-change="handlePageChange"
    >
      <template #user="{ record }">
        <a-tooltip :content="`用户ID：${record.user_id}`">
          <span>{{ record.user_name }}</span>
        </a-tooltip>
      </template>
      <template #amount="{ record }">
        {{ record.amount.toFixed(2) }}
      </template>
      <template #due_date="{ record }">
        {{ dayjs.tz(record.due_date).format('YYYY-MM-DD') }}
      </template>
      <template #payment_status="{ record }">
        <a-tag v-if="dayjs.tz() > dayjs.tz(record.due_date)">
          已过期
        </a-tag>
        <a-tag v-else-if="record.payment_status">
          已支付
        </a-tag>
        <a-tag v-else>
          未支付
        </a-tag>
      </template>
      <template #created_at="{ record }">
        {{ dayjs.tz(record.created_at).format('YYYY-MM-DD HH:mm:ss') }}
      </template>
    </a-table>
  </a-card>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import type { TableColumnData } from '@arco-design/web-vue/es/table/interface'
import { Message } from '@arco-design/web-vue'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type getFeeBillData } from '@/api/adminApi'

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

const { getFeeBill } = useAdminApi()

const columns: TableColumnData[] = [
  {
    title: '账单ID',
    dataIndex: 'bill_id'
  },
  {
    title: '用户',
    slotName: 'user'
  },
  {
    title: '账单金额',
    slotName: 'amount'
  },
  {
    title: '截至日期',
    slotName: 'due_date'
  },
  {
    title: '账单周期',
    dataIndex: 'fee_period'
  },
  {
    title: '支付状态',
    slotName: 'payment_status'
  },
  {
    title: '账单生成日期',
    slotName: 'created_at'
  }
]

const tableData = reactive<getFeeBillData[]>([])
const fetchBillLoading = ref(false)

const pageInfo = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

async function fetchBills() {
  try {
    fetchBillLoading.value = true
    const { data } = await handleXhrResponse(() => getFeeBill(pageInfo.pageSize, pageInfo.pageNum), Message)
    tableData.splice(0, tableData.length, ...data.data.history)
    pageInfo.total = data.data.total
    fetchBillLoading.value = false
  }
  catch (e) {
    fetchBillLoading.value = false
    Message.error('获取类型数据失败')
    console.error(e)
  }
}

async function handlePageChange(pageNum: number) {
  pageInfo.pageNum = pageNum
  await fetchBills()
}

onMounted(async () => {
  await fetchBills()
})
</script>

<style scoped lang="less">

</style>
