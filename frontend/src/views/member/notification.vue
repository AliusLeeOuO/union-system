<template>
  <div class="notification-top">
    <h1>我的通知</h1>
    <a-space>
      <a-button @click="refreshNotifications">
        <template #icon>
          <icon-refresh />
        </template>
        刷新
      </a-button>
      <a-button @click="fetchReadAll">一键已读</a-button>
    </a-space>
  </div>
  <div class="notification-items">
    <notification-block
      v-for="item in notificationList"
      :key="item.notification_id"
      :id="item.notification_id"
      :title="item.title"
      :create-time="item.created_at"
      :read-status="item.read_status"
      :sender-role="item.sender_role"
      :sender-username="item.sender_name"
      @update-list="fetchNotificationList"
    >
      <template v-slot:content>
        {{ item.content }}
      </template>
    </notification-block>
  </div>
  <div class="pagination">
    <a-pagination :total="notificationPageData.total" @change="pageChange" />
  </div>
</template>
<script setup lang="ts">
import NotificationBlock from "@/components/notificationBlock.vue"
import useMemberApi, { type notificationResponseObject } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { useNotificationStore } from "@/stores/notification"
import { Message } from "@arco-design/web-vue"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import { onMounted, reactive } from "vue"

const memberApi = useMemberApi()

const notificationPageData = reactive({
  total: 0,
  pageSize: 10,
  pageNum: 1
})

const notificationList = reactive<notificationResponseObject[]>([])

const notificationStore = useNotificationStore()
const fetchNotificationList = async () => {
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

const pageChange = async (current: number) => {
  notificationPageData.pageNum = current
  await fetchNotificationList()
}


// 一键已读
const fetchReadAll = async () => {
  await handleXhrResponse(
    () => memberApi.notificationReadAll(),
    Message
  )
  Message.success("已全部标记为已读")
  await fetchNotificationList()
}

// 刷新页面
const refreshNotifications = async () => {
  notificationPageData.pageNum = 1 // 将分页设置回第一页
  await fetchNotificationList() // 重新加载通知列表
  Message.success("通知列表已刷新")
}

onMounted(() => {
  fetchNotificationList()
})
</script>
<style scoped lang="less">
.notification-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 60px;

  h1 {
    font-size: 20px;
  }
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}
</style>
