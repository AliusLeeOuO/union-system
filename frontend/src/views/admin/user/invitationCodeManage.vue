<template>
  <div class="prime-actions">
    <a-space>
      <a-button status="success" @click="fetchGetNewInvitationCode">生成新邀请码</a-button>
    </a-space>
<!--    <a-space>-->
<!--      <a-button @click="submitSearch">-->
<!--        <template #icon>-->
<!--          <icon-refresh />-->
<!--        </template>-->
<!--        刷新-->
<!--      </a-button>-->
<!--    </a-space>-->
  </div>
  <div class="tooltip-zone" v-if="getNewInvitationCodeSuccess">
    <a-alert type="success" closable @close="closeInvitationAlert">新邀请码生成成功！</a-alert>
  </div>
  <div class="action-zone">
<!--    <a-form :models="searchForm" layout="inline">-->
<!--      <a-form-item label="状态">-->
<!--        <a-select :style="{width:'180px'}" v-models="searchForm.status">-->
<!--          <a-option value="all">所有</a-option>-->
<!--          <a-option value="true">已使用</a-option>-->
<!--          <a-option value="false">未使用</a-option>-->
<!--        </a-select>-->
<!--      </a-form-item>-->
<!--    </a-form>-->
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
      <a-tag color="cyan" v-if="record.is_used">已使用</a-tag>
      <a-tag color="gray" v-else-if="dayjs.tz(record.expires_at).isBefore(dayjs.tz())">已过期</a-tag>
      <a-tag color="green" v-else>未使用</a-tag>
    </template>
    <template #created_at="{ record }">
      {{ dayjs.tz(record.created_at).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
    <template #expired_at="{ record }">
      {{ dayjs.tz(record.expires_at).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { onMounted, reactive, ref, watch } from "vue"
import useAdminApi, { type invitationCodeListItem, type loginLogItem } from "@/api/adminApi"
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
    title: "邀请码ID",
    dataIndex: "code_id"
  },
  {
    title: "邀请码",
    dataIndex: "code"
  },
  {
    title: "使用状态",
    slotName: "status"
  },
  {
    title: "创建时间",
    slotName: "created_at"
  },
  {
    title: "过期时间",
    slotName: "expired_at"
  }
]

const tableData = reactive<invitationCodeListItem[]>([])

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

const fetchCodeList = async () => {
  const { data } = await handleXhrResponse(() => adminApi.getInvitationCodeList(pageData.currentPage, pageData.pageSize), Message)
  tableData.splice(0, tableData.length)
  pageData.total = data.data.total
  if (data.data.data) {
    tableData.push(...data.data.data)
  }
}

const getNewInvitationCodeSuccess = ref(false)
const fetchGetNewInvitationCode = async () => {
  await handleXhrResponse(() => adminApi.generateInvitationCode(), Message)
  await fetchCodeList()
  getNewInvitationCodeSuccess.value = true
}

const closeInvitationAlert = (ev: MouseEvent) => {
  getNewInvitationCodeSuccess.value = false
}

const changePage = async (page: number) => {
  pageData.currentPage = page
  await fetchCodeList()
}

const refreshList = async () => {
  pageData.currentPage = 1
  searchForm.status = "all"
  await fetchCodeList()
}

// 监听searchForm.status的变化，并在变化时调用fetchLoginLog
watch(() => searchForm.status, async (newStatus, oldStatus) => {
  pageData.currentPage = 1
  await fetchCodeList()
})

onMounted(async () => {
  await fetchCodeList()
})
</script>
<style scoped lang="less">
.prime-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}
.tooltip-zone {
  margin-bottom: 10px;
}
.action-zone {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}
</style>
