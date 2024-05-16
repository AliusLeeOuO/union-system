<template>
  <a-empty v-if="memberActivityList.length === 0" />
  <div v-else class="activity-content">
    <div class="activity-items">
      <ActivityBlock
        v-for="item in memberActivityList"
        :key="item.activityId"
        :path="`/member/activityDetail/${item.activityId}`"
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
    <div class="flex justify-end flex-items-center p-4">
      <a-pagination
        v-model:page-size="pagination.pageSize"
        v-model:current="pagination.current"
        :total="pagination.total"
        :default-page-size="5"
        show-page-size @change="memberPageChange"
        @page-size-change="memberPageSizeChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'
import ActivityBlock from '@/components/activityBlock.vue'
import type { activityListResponse } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import useMemberApi from '@/api/memberApi'

const memberApi = useMemberApi()
const memberActivityList = reactive<activityListResponse[]>([])
const pagination = reactive({
  total: 0,
  pageSize: 5,
  current: 1
})

async function memberPageChange(current: number) {
  pagination.current = current
  await getActivityMemberList()
}

async function memberPageSizeChange(pageSize: number) {
  pagination.pageSize = pageSize
  pagination.current = 1
  await getActivityMemberList()
}

async function getActivityMemberList() {
  const { data } = await handleXhrResponse(() => memberApi.activityMemberList(pagination.pageSize, pagination.current), Message)
  if (data.data.data === null) {
    return
  }

  // 清除原有数据
  memberActivityList.splice(0, memberActivityList.length)
  memberActivityList.push(...data.data.data!)
  pagination.total = data.data.total
}

onMounted(async () => {
  await getActivityMemberList()
})
</script>
