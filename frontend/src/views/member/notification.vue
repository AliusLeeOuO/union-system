<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{route, paths}">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <div class="notification-top flex justify-between flex-items-center">
    <a-typography-title :heading="2">
      我的通知
    </a-typography-title>
    <a-space>
      <a-button @click="fetchReadAll" v-if="notificationList.length !== 0">一键已读</a-button>
      <a-button @click="refreshNotifications">
        <template #icon>
          <icon-refresh />
        </template>
        刷新
      </a-button>
    </a-space>
  </div>
  <div v-if="notificationList.length === 0">
    <a-empty />
  </div>
  <div v-else>
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
    <div class="flex justify-end flex-items-center mt-4">
      <a-pagination :total="notificationPageData.total" @change="pageChange" />
    </div>
  </div>
</template>
<script setup lang="ts">
import NotificationBlock from "@/components/notificationBlock.vue"
import useMemberApi, { type notificationResponseObject } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { useNotificationStore } from "@/stores/notification"
import { type BreadcrumbRoute, Message } from "@arco-design/web-vue"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import { onMounted, reactive } from "vue"

const memberApi = useMemberApi()

const routes: BreadcrumbRoute[] = [
  {
    path: "/member/notification",
    label: "通知"
  }
]

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
  height: 60px;
  :deep(.arco-typography) {
    margin: 0;
  }

  h1 {
    font-size: 20px;
  }
}
</style>
