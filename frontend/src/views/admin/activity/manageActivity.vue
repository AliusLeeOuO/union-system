<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{ route }">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <a-typography-title :heading="2">
    活动管理
  </a-typography-title>
  <div class="flex justify-between flex-items-center">
    <a-space>
      <router-link v-slot="{ navigate }" to="/admin/addNewActivity" custom>
        <a-button status="success" @click="navigate">
          添加新活动
        </a-button>
      </router-link>
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
    <div class="activity-items">
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
</template>

<script setup lang="ts">
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import { onMounted, reactive } from 'vue'
import { type BreadcrumbRoute, Message } from '@arco-design/web-vue'
import type { activityListResponse } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import useAdminApi from '@/api/adminApi'
import ActivityBlock from '@/components/activityBlock.vue'

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
</script>
