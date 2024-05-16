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
    活动详情
  </a-typography-title>
  <div class="activity-detail-content">
    <div class="activity-detail-item">
      <div class="description-title">
        活动名称
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.title }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        活动描述
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.description }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        活动类型
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.activityTypeName }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        报名人数
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.registrationCount }}/{{ activityDetail.maxParticipants
        }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        活动地址
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.location }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        活动时间
      </div>
      <div class="activity-detail-item-content">
        {{ dayjs.tz(activityDetail.startTime).format("YYYY年MM月DD日 HH:mm") }}
        -
        {{ dayjs.tz(activityDetail.endTime).format("YYYY年MM月DD日 HH:mm") }}
      </div>
    </div>
  </div>
  <div>
    <a-button v-if="userActivityStatus.isRegistered" long size="large" @click="signUpActivity">
      报名活动
    </a-button>
    <a-button v-else long size="large" status="warning" @click="cancelSignUpActivity">
      取消报名
    </a-button>
  </div>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { onMounted, reactive } from 'vue'
import { type BreadcrumbRoute, Message } from '@arco-design/web-vue'
import { useRoute } from 'vue-router'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useMemberApi from '@/api/memberApi'

dayjs.extend(timezone)
dayjs.extend(utc)
dayjs.tz.setDefault('Asia/Shanghai')

const memberApi = useMemberApi()
const route = useRoute()

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: '/member/activity',
    label: '活动'
  },
  {
    path: route.path,
    label: '查看活动'
  }
]

const activityDetail = reactive({
  title: '',
  description: '',
  registrationCount: 0,
  maxParticipants: 0,
  location: '',
  startTime: '1970-01-01T08:00:00+08:00',
  endTime: '1970-01-01T08:00:00+08:00',
  activityTypeName: ''
})

const activityId = Number(route.params.id)

// 报名活动
async function signUpActivity() {
  await handleXhrResponse(() => memberApi.activityRegister(activityId), Message)
  Message.success('报名成功')
  await getActivityDetail(activityId)
}

// 取消报名
async function cancelSignUpActivity() {
  await handleXhrResponse(() => memberApi.activityCancel(activityId), Message)
  Message.success('取消报名成功')
  await getActivityDetail(activityId)
}

const userActivityStatus = reactive({
  isRegistered: false
})

async function getActivityDetail(activityId: number) {
  const { data } = await handleXhrResponse(() => memberApi.activityDetail(activityId), Message)
  activityDetail.title = data.data.activity.title
  activityDetail.description = data.data.activity.description
  activityDetail.registrationCount = data.data.activity.registrationCount
  activityDetail.maxParticipants = data.data.activity.maxParticipants
  activityDetail.location = data.data.activity.location
  activityDetail.startTime = data.data.activity.startTime
  activityDetail.endTime = data.data.activity.endTime
  activityDetail.activityTypeName = data.data.activity.activityTypeName
  userActivityStatus.isRegistered = data.data.isRegistered
}

onMounted(async () => {
  const activityId = Number(route.params.id)
  await getActivityDetail(activityId)
})
</script>

<style scoped lang="less">
.activity-detail-content {
  padding: 10px;

  .activity-detail-item {
    padding-bottom: 10px;

    &:not(:last-child) {
      border-bottom: 1px solid #f0f0f0;
    }
  }
}

.description-title {
  margin-top: 10px;
  font-size: 16px;
  padding-bottom: 10px;

  &::before {
    content: "";
    display: inline-block;
    width: 8px; /* 方块的宽度 */
    height: 18px; /* 方块的高度 */
    background-color: rgb(var(--primary-6)); /* 方块的颜色 */
    margin-right: 8px; /* 和文本之间的距离 */
    vertical-align: middle;
  }
}

.activity-detail-item-content {
  line-height: 28px;
}
</style>
