<template>
  <div class="flex justify-between mb-3">
<!--    <a-form :models="searchForm" layout="inline">
      <a-form-item label="状态">
        <a-select :style="{width:'180px'}" v-models="searchForm.status">
          <a-option value="all">所有</a-option>
          <a-option value="true">成功</a-option>
          <a-option value="false">失败</a-option>
        </a-select>
      </a-form-item>
    </a-form>-->
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
      {{ dayjs.tz(record.time).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { onMounted, reactive, watch } from "vue"
import useAdminApi, { type logAdminListItem } from "@/api/adminApi"
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
    title: "操作用户名",
    slotName: "username"
  },
  {
    title: "操作模块",
    slotName: "actionModule"
  },
  {
    title: "操作IP",
    dataIndex: "ip"
  },
  {
    title: "操作详情",
    slotName: "detail",
    ellipsis: true,
    width: 500
  },
  {
    title: "操作时间",
    slotName: "time",
    width: 200
  }
]

const tableData = reactive<logAdminListItem[]>([])

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

const fetchLoginLog = async () => {
  const { data } = await handleXhrResponse(() => adminApi.getLogAdminList(pageData.currentPage, pageData.pageSize), Message)
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
