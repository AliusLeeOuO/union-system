<template>
  <a-card class="mb-4">
    <div class="flex justify-between flex-items-center">
      <a-space>
        <a-button v-if="notificationList.length !== 0" @click="fetchReadAll">
          一键已读
        </a-button>
        <a-button @click="refreshNotifications">
          <template #icon>
            <IconRefresh />
          </template>
          刷新
        </a-button>
      </a-space>
    </div>
  </a-card>
  <div v-if="notificationList.length === 0">
    <a-card>
      <a-empty />
    </a-card>
  </div>
  <div v-else>
    <div class="notification-items">
      <NotificationBlock
        v-for="item in notificationList"
        :id="item.notification_id"
        :key="item.notification_id"
        :title="item.title"
        :create-time="item.created_at"
        :read-status="item.read_status"
        :sender-role="item.sender_role"
        :sender-username="item.sender_name"
        @update-list="fetchNotificationList"
      >
        <template #content>
          {{ item.content }}
        </template>
      </NotificationBlock>
    </div>
    <div class="mt-4 flex justify-end flex-items-center">
      <a-pagination :total="notificationPageData.total" @change="pageChange" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { Message } from '@arco-design/web-vue'
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import { onMounted, reactive } from 'vue'
import NotificationBlock from '@/components/notificationBlock.vue'
import useMemberApi, { type notificationResponseObject } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import { useNotificationStore } from '@/stores/notification'

const memberApi = useMemberApi()

const notificationPageData = reactive({
  total: 0,
  pageSize: 10,
  pageNum: 1
})

const notificationList = reactive<notificationResponseObject[]>([])

const notificationStore = useNotificationStore()

async function fetchNotificationList() {
  const { data } = await handleXhrResponse(
    () => memberApi.notificationList(notificationPageData.pageSize, notificationPageData.pageNum),
    Message
  )
  notificationList.splice(0, notificationList.length)
  notificationPageData.total = data.data.total
  if (data.data.notifications === null) {
    return
  }

  notificationList.push(...data.data.notifications)
  await notificationStore.refreshNotificationCount()
}

async function pageChange(current: number) {
  notificationPageData.pageNum = current
  await fetchNotificationList()
}

// 一键已读
async function fetchReadAll() {
  await handleXhrResponse(
    () => memberApi.notificationReadAll(),
    Message
  )
  Message.success('已全部标记为已读')
  await fetchNotificationList()
}

// 刷新页面
async function refreshNotifications() {
  notificationPageData.pageNum = 1 // 将分页设置回第一页
  await fetchNotificationList() // 重新加载通知列表
  Message.success('通知列表已刷新')
}

onMounted(() => {
  fetchNotificationList()
})
</script>

<style scoped lang="less">
.notification-top {
  height: 60px;

  :deep(.arco-typography) {
    margin: 0;
  }

  h1 {
    font-size: 20px;
  }
}
</style>
