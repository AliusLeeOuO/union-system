<template>
  <div class="flex justify-between">
    <a-form :model="searchForm" layout="inline">
      <a-form-item label="状态">
        <a-select :style="{width:'180px'}" v-model="searchForm.status">
          <a-option value="all">所有</a-option>
          <a-option value="true">成功</a-option>
          <a-option value="false">失败</a-option>
        </a-select>
      </a-form-item>
    </a-form>
    <a-button @click="refreshList">
      <template #icon>
        <icon-refresh />
      </template>
      刷新
    </a-button>
  </div>
  <a-table
    :columns="columns"
    :data="tableData"
    size="large"
    @page-change="changePage"
    :pagination="{
      total: pageData.total,
      pageSize: pageData.pageSize,
      current: pageData.currentPage
    }"
  >
    <template #status="{ record }">
      <a-tag color="green" v-if="record.status">成功</a-tag>
      <a-tag color="red" v-else>失败</a-tag>
    </template>
    <template #login_time="{ record }">
      {{ dayjs.tz(record.login_time).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { onMounted, reactive, watch } from "vue"
import useAdminApi, { type loginLogItem } from "@/api/adminApi"
import { handleXhrResponse } from "@/api"
import { Message } from "@arco-design/web-vue"
import dayjs from "dayjs"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const adminApi = useAdminApi()

const searchForm = reactive<{
  status: "all" | "true" | "false"
}>({
  status: "all"
})

const columns = [
  {
    title: "登录IP",
    dataIndex: "ip"
  },
  {
    title: "登录用户名",
    dataIndex: "username"
  },
  {
    title: "登录UA",
    dataIndex: "ua"
  },
  {
    title: "登录状态",
    slotName: "status"
  },
  {
    title: "登录时间",
    slotName: "login_time"
  }
]

const tableData = reactive<loginLogItem[]>([])

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

const fetchLoginLog = async () => {
  const { data } = await handleXhrResponse(() => adminApi.getLoginLog(pageData.currentPage, pageData.pageSize, searchForm.status), Message)
  tableData.splice(0, tableData.length)
  pageData.total = data.data.total
  if (data.data.data) {
    tableData.push(...data.data.data)
  }
}

const changePage = async (page: number) => {
  pageData.currentPage = page
  await fetchLoginLog()
}

const refreshList = async () => {
  pageData.currentPage = 1
  searchForm.status = "all"
  await fetchLoginLog()
}

// 监听searchForm.status的变化，并在变化时调用fetchLoginLog
watch(() => searchForm.status, async (newStatus, oldStatus) => {
  pageData.currentPage = 1
  await fetchLoginLog()
})

onMounted(async () => {
  await fetchLoginLog()
})
</script>
