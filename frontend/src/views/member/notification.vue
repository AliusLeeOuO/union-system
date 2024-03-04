<template>
  <div class="notification-top">
    <h1>我的通知</h1>
    <a-button>一键已读</a-button>
  </div>
  <div class="notification-items">
    <notification-block
      v-for="item in notificationList"
      :key="item.notification_id"
      :title="item.title"
      :create-time="item.created_at"
      :read-status="item.read_status"
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
import { Message } from "@arco-design/web-vue"
import { onMounted, reactive } from "vue"

const memberApi = useMemberApi()

const notificationPageData = reactive({
  total: 0,
  pageSize: 10,
  pageNum: 1
})

const notificationList = reactive<notificationResponseObject[]>([])

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
}

const pageChange = async (current: number) => {
  notificationPageData.pageNum = current
  fetchNotificationList()
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
