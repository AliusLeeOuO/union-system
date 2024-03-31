<template>
  <div class="activity-content">
    <div class="activity-items">
      <activity-block
        v-for="item in activityList"
        :key="item.activityId"
        :path="'/member/activityDetail/' + item.activityId"
        :activity-id="item.activityId"
        :title="item.title"
        :registration-count="item.registrationCount"
        :activity-type-name="item.activityTypeName"
        :description="item.description"
        :location="item.location"
        :start-time="item.startTime"
        :end-time="item.endTime"
        :max-participants="item.maxParticipants"
      />
    </div>
    <div class="activity-pagination">
      <a-pagination
        :total="pagination.total"
        v-model:page-size="pagination.pageSize"
        v-model:current="pagination.current"
        :default-page-size="5"
        show-page-size @change="pageChange"
        @page-size-change="pageSizeChange"
      />
    </div>
  </div>
</template>
<script setup lang="ts">
import ActivityBlock from "@/components/activityBlock.vue"
import { onMounted, reactive } from "vue"
import type { activityListResponse } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { type BreadcrumbRoute, Message } from "@arco-design/web-vue"
import useMemberApi from "@/api/memberApi"

const memberApi = useMemberApi()
const activityList = reactive<activityListResponse[]>([])
const pagination = reactive({
  total: 0,
  pageSize: 5,
  current: 1
})

const pageSizeChange = async (pageSize: number) => {
  pagination.pageSize = pageSize
  pagination.current = 1
  await getActivityList()
}

const pageChange = async (current: number) => {
  pagination.current = current
  await getActivityList()
}

const getActivityList = async () => {
  const { data } = await handleXhrResponse(() => memberApi.activityList(pagination.pageSize, pagination.current), Message)
  // 先判断是否有数据
  if (data.data.data === null) {
    return
  }
  // 清除原有数据
  activityList.splice(0, activityList.length)
  activityList.push(...data.data.data!)
  pagination.total = data.data.total
}

onMounted(async () => {
  await getActivityList()
})
</script>

<style scoped lang="less">
.activity-pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}
</style>