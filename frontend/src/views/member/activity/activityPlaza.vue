<template>
  <a-card>
    <div class="activity-content">
      <div class="activity-items flex flex-col gap-4">
        <router-link
          v-for="item in activityList"
          :key="item.activityId"
          :to="`/member/activityDetail/${item.activityId}`"
          class="decoration-none"
        >
          <ActivityBlock
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
        </router-link>
      </div>
      <div class="flex justify-end flex-items-center p-4">
        <a-pagination
          v-model:page-size="pagination.pageSize"
          v-model:current="pagination.current"
          :total="pagination.total"
          :default-page-size="5"
          show-page-size @change="pageChange"
          @page-size-change="pageSizeChange"
        />
      </div>
    </div>
  </a-card>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'
import ActivityBlock from '@/components/activityBlock.vue'
import type { activityListResponse } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import useMemberApi from '@/api/memberApi'

const memberApi = useMemberApi()
const activityList = reactive<activityListResponse[]>([])
const pagination = reactive({
  total: 0,
  pageSize: 5,
  current: 1
})

async function pageSizeChange(pageSize: number) {
  pagination.pageSize = pageSize
  pagination.current = 1
  await getActivityList()
}

async function pageChange(current: number) {
  pagination.current = current
  await getActivityList()
}

async function getActivityList() {
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
