<template>
  <div class="flex justify-between">
    <a-form :model="searchForm" layout="inline">
      <a-form-item label="状态">
        <a-select v-model="searchForm.status" :style="{ width: '180px' }">
          <a-option value="all">
            所有
          </a-option>
          <a-option value="true">
            成功
          </a-option>
          <a-option value="false">
            失败
          </a-option>
        </a-select>
      </a-form-item>
    </a-form>
    <a-button @click="refreshList">
      <template #icon>
        <IconRefresh />
      </template>
      刷新
    </a-button>
  </div>
  <a-table
    :columns="columns"
    :data="tableData"
    size="large"
    :pagination="{
      total: pageData.total,
      pageSize: pageData.pageSize,
      current: pageData.currentPage,
    }"
    @page-change="changePage"
  >
    <template #status="{ record }">
      <a-tag v-if="record.status" color="green">
        成功
      </a-tag>
      <a-tag v-else color="red">
        失败
      </a-tag>
    </template>
    <template #login_time="{ record }">
      {{ dayjs.tz(record.login_time).format('YYYY-MM-DD HH:mm:ss') }}
    </template>
  </a-table>
</template>

<script setup lang="ts">
import { onMounted, reactive, watch } from 'vue'
import { Message } from '@arco-design/web-vue'
import dayjs from 'dayjs'
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type loginLogItem } from '@/api/adminApi'

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
    title: '登录IP',
    dataIndex: 'ip'
  },
  {
    title: '登录用户名',
    dataIndex: 'username'
  },
  {
    title: '登录UA',
    dataIndex: 'ua'
  },
  {
    title: '登录状态',
    slotName: 'status'
  },
  {
    title: '登录时间',
    slotName: 'login_time'
  }
]

const tableData = reactive<loginLogItem[]>([])

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

async function fetchLoginLog() {
  const { data } = await handleXhrResponse(() => adminApi.getLoginLog(pageData.currentPage, pageData.pageSize, searchForm.status), Message)
  tableData.splice(0, tableData.length)
  pageData.total = data.data.total
  if (data.data.data) {
    tableData.push(...data.data.data)
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
