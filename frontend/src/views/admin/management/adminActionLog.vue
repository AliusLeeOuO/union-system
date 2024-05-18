<template>
  <a-card class="mb-4">
    <div class="flex justify-between">
      <a-space />
      <a-space>
        <a-button @click="refreshList">
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
      size="large"
      :loading="tableLoading"
      :pagination="{
        total: pageData.total,
        pageSize: pageData.pageSize,
        current: pageData.currentPage,
      }"
      @page-change="changePage"
    >
      <template #username="{ record }">
        <a-popover>
          <div>
            {{ record.user.username }}
          </div>
          <template #content>
            <p>用户ID：{{ record.user.id }}</p>
          </template>
        </a-popover>
      </template>
      <template #detail="{ record }">
        <a-popover>
          <div>
            {{ record.detail }}
          </div>
          <template #content>
            <p>{{ record.detail }}</p>
          </template>
        </a-popover>
      </template>
      <template #actionModule="{ record }">
        <a-popover>
          <div>
            {{ record.action.name }}
          </div>
          <template #content>
            <p>模块ID：{{ record.action.id }}</p>
          </template>
        </a-popover>
      </template>
      <template #time="{ record }">
        {{ dayjs.tz(record.time).format('YYYY-MM-DD HH:mm:ss') }}
      </template>
    </a-table>
  </a-card>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref, watch } from 'vue'
import { Message } from '@arco-design/web-vue'
import dayjs from 'dayjs'
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type logAdminListItem } from '@/api/adminApi'

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

const adminApi = useAdminApi()

const searchForm = reactive<{
  status: 'all' | 'true' | 'false'
}>({
  status: 'all'
})

const columns = [
  {
    title: '操作用户名',
    slotName: 'username'
  },
  {
    title: '操作模块',
    slotName: 'actionModule'
  },
  {
    title: '操作IP',
    dataIndex: 'ip'
  },
  {
    title: '操作详情',
    slotName: 'detail',
    ellipsis: true,
    width: 500
  },
  {
    title: '操作时间',
    slotName: 'time',
    width: 200
  }
]

const tableData = reactive<logAdminListItem[]>([])
const tableLoading = ref(false)

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

async function fetchLoginLog() {
  try {
    tableLoading.value = true
    const { data } = await handleXhrResponse(() => adminApi.getLogAdminList(pageData.currentPage, pageData.pageSize), Message)
    pageData.total = data.data.total
    if (data.data.data) {
      tableData.splice(0, tableData.length, ...data.data.data)
    }
  }
  catch (e) {
    console.error(e)
  }
  finally {
    tableLoading.value = false
  }
}

async function changePage(page: number) {
  pageData.currentPage = page
  await fetchLoginLog()
}

async function refreshList() {
  pageData.currentPage = 1
  searchForm.status = 'all'
  await fetchLoginLog()
}

// 监听searchForm.status的变化，并在变化时调用fetchLoginLog
watch(() => searchForm.status, async () => {
  pageData.currentPage = 1
  await fetchLoginLog()
})

onMounted(async () => {
  await fetchLoginLog()
})
</script>
