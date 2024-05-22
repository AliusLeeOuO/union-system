<template>
  <a-card class="mb-4">
    <div class="flex justify-between flex-items-center">
      <a-space>
        <a-button status="success" @click="fetchGetNewInvitationCode">
          生成新邀请码
        </a-button>
      </a-space>
    </div>
  </a-card>
  <a-card class="mb-4">
    <div class="flex justify-between">
      <a-space />
      <a-button @click="refreshList">
        <template #icon>
          <IconRefresh />
        </template>
        刷新
      </a-button>
    </div>
  </a-card>
  <div v-if="getNewInvitationCodeSuccess" class="mb-4">
    <a-alert type="success" closable @close="closeInvitationAlert">
      新邀请码生成成功！
    </a-alert>
  </div>
  <a-card>
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
        <a-tag v-if="record.is_used" color="cyan">
          已使用
        </a-tag>
        <a-tag v-else-if="dayjs.tz(record.expires_at).isBefore(dayjs.tz())" color="gray">
          已过期
        </a-tag>
        <a-tag v-else color="green">
          未使用
        </a-tag>
      </template>
      <template #created_at="{ record }">
        {{ dayjs.tz(record.created_at).format('YYYY-MM-DD HH:mm:ss') }}
      </template>
      <template #expired_at="{ record }">
        {{ dayjs.tz(record.expires_at).format('YYYY-MM-DD HH:mm:ss') }}
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
import useAdminApi, { type invitationCodeListItem } from '@/api/adminApi'

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
    title: '邀请码ID',
    dataIndex: 'code_id'
  },
  {
    title: '邀请码',
    dataIndex: 'code'
  },
  {
    title: '使用状态',
    slotName: 'status'
  },
  {
    title: '创建时间',
    slotName: 'created_at'
  },
  {
    title: '过期时间',
    slotName: 'expired_at'
  }
]

const tableData = reactive<invitationCodeListItem[]>([])

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

async function fetchCodeList() {
  const { data } = await handleXhrResponse(() => adminApi.getInvitationCodeList(pageData.currentPage, pageData.pageSize), Message)
  tableData.splice(0, tableData.length)
  pageData.total = data.data.total
  if (data.data.data) {
    tableData.push(...data.data.data)
  }
}

const getNewInvitationCodeSuccess = ref(false)

async function fetchGetNewInvitationCode() {
  await handleXhrResponse(() => adminApi.generateInvitationCode(), Message)
  await fetchCodeList()
  getNewInvitationCodeSuccess.value = true
}

function closeInvitationAlert() {
  getNewInvitationCodeSuccess.value = false
}

async function changePage(page: number) {
  pageData.currentPage = page
  await fetchCodeList()
}

async function refreshList() {
  pageData.currentPage = 1
  searchForm.status = 'all'
  await fetchCodeList()
}

// 监听searchForm.status的变化，并在变化时调用fetchLoginLog
watch(() => searchForm.status, async () => {
  pageData.currentPage = 1
  await fetchCodeList()
})

onMounted(async () => {
  await fetchCodeList()
})
</script>
