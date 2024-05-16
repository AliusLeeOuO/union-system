<template>
  <div class="mb-4 flex justify-between flex-items-center">
    <a-space>
      <a-button status="success" @click="showNewActivity">
        添加新活动
      </a-button>
    </a-space>
    <a-space>
      <a-button>
        <template #icon>
          <IconRefresh />
        </template>
        刷新
      </a-button>
    </a-space>
  </div>
  <a-empty v-if="activityList.length === 0" />
  <div v-else class="activity-content">
    <div class="activity-items flex flex-col gap-4">
      <ActivityBlock
        v-for="item in activityList"
        :key="item.activityId"
        :path="`/admin/manageActivityDetail/${item.activityId}`"
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
    <div class="mt-4 flex justify-end">
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
  <a-drawer :width="700" :visible="newActivityVisible" unmount-on-close :footer="false" @cancel="handleNewActivityCancel">
    <template #title>
      创建新活动
    </template>
    <AddNewActivity @close-drawer="handleNewActivityCancel" />
  </a-drawer>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { type BreadcrumbRoute, Message } from '@arco-design/web-vue'
import type { activityListResponse } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import useAdminApi from '@/api/adminApi'
import ActivityBlock from '@/components/activityBlock.vue'
import AddNewActivity from '@/views/admin/activity/addNewActivity.vue'

const adminApi = useAdminApi()

const routes: BreadcrumbRoute[] = [
  {
    path: '/admin/manageActivity',
    label: '活动管理'
  }
]

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
  const { data } = await handleXhrResponse(() => adminApi.activityList(pagination.pageSize, pagination.current), Message)
  // 清除原有数据
  activityList.splice(0, activityList.length)
  pagination.total = data.data.total
  // 先判断是否有数据
  if (data.data.data !== null) {
    activityList.push(...data.data.data!)
  }
}

onMounted(async () => {
  await getActivityList()
})

// 新活动抽屉
const newActivityVisible = ref(false)
function showNewActivity() {
  newActivityVisible.value = true
}
function handleNewActivityCancel() {
  newActivityVisible.value = false
}
</script>
