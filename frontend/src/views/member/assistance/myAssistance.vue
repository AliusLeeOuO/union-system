<template>
  <div class="my-assistant-overview grid grid-cols-3 p-4">
    <div class="my-assistant-overview-block text-center">
      <a-statistic title="总工单数" :value="overviewItem.total" :value-from="0" animation />
    </div>
    <div class="my-assistant-overview-block text-center">
      <a-statistic title="待我处理" :value="overviewItem.resolved" :value-from="0" animation />
    </div>
    <div class="my-assistant-overview-block text-center">
      <a-statistic title="处理中" :value="overviewItem.pending" :value-from="0" animation />
    </div>
  </div>
  <a-table
    :columns="columns" :data="tableData" size="large" :pagination="{
      total: overviewItem.total,
      pageSize: 10,
    }" @page-change="changePage"
  >
    <template #status="{ record }">
      <a-tag v-if="record.status_id === 1" color="cyan">
        待审核
      </a-tag>
      <a-tag v-else-if="record.status_id === 2" color="blue">
        处理中
      </a-tag>
      <a-tag v-else-if="record.status_id === 3" color="green">
        已解决
      </a-tag>
      <a-tag v-else-if="record.status_id === 4" color="gray">
        已关闭
      </a-tag>
    </template>
    <template #action="{ record }">
      <router-link :to="`/member/assistance/assistanceDetail/${record.assistance_id}`">
        <a-button>查看</a-button>
      </router-link>
    </template>
  </a-table>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import type { assistanceListResponse } from '@/api/memberApi'
import useMemberApi from '@/api/memberApi'

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')
// const router = useRouter()
const memberApi = useMemberApi()

const pageItem = reactive({
  pageSize: 10,
  current: 1
})

const tableData = reactive<assistanceListResponse[]>([])
const overviewItem = reactive({
  total: 0,
  pending: 0,
  resolved: 0
})

async function getMyRequest() {
  const { data } = await handleXhrResponse(() => memberApi.assistanceList(pageItem.pageSize, pageItem.current), Message)
  // 清除原有数据
  tableData.splice(0, tableData.length)
  overviewItem.total = data.data.total
  overviewItem.pending = data.data.pending_review_count
  overviewItem.resolved = data.data.resolved_count
  if (data.data.assistances === null) {
    return
  }

  data.data.assistances.forEach((item: assistanceListResponse) => {
    tableData.push({
      title: item.title,
      assistance_id: item.assistance_id,
      assistance_type: item.assistance_type,
      assistance_type_id: item.assistance_type_id,
      description: item.description,
      request_date: dayjs.tz(item.request_date).format('YYYY-MM-DD HH:mm:ss'),
      status: item.status,
      status_id: item.status_id
    })
  })
}

const columns = [
  {
    title: '请求编号',
    dataIndex: 'assistance_id'
  },
  {
    title: '标题',
    dataIndex: 'title'
  },
  {
    title: '类型',
    dataIndex: 'assistance_type'
  },
  {
    title: '状态',
    slotName: 'status'
  },
  {
    title: '提交时间',
    dataIndex: 'request_date'
  },
  {
    title: '操作',
    slotName: 'action'
  }
]

async function changePage(page: number) {
  pageItem.current = page
  await getMyRequest()
}

onMounted(async () => {
  await getMyRequest()
})
</script>

<style scoped lang="less">
.my-assistant-overview {
  grid-gap: 5px;
  padding: 20px;
}
</style>
