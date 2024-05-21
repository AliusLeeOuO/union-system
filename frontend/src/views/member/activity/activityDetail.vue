<template>
  <a-card title="活动名称" class="mb-4">
    <span class="break-all line-height-6">{{ activityDetail.title }}</span>
  </a-card>
  <a-card title="活动描述" class="mb-4">
    <span class="break-all line-height-6">{{ activityDetail.description }}</span>
  </a-card>
  <a-card title="活动类型" class="mb-4">
    <span class="break-all line-height-6">{{ activityDetail.activityTypeName }}</span>
  </a-card>
  <a-card title="报名人数" class="mb-4">
    <div class="flex gap-2">
      <span class="whitespace-nowrap">{{ activityDetail.registrationCount }}/{{ activityDetail.maxParticipants }}</span>
      <a-progress :percent="activityDetail.registrationCount / activityDetail.maxParticipants" :show-text="false" />
    </div>
  </a-card>
  <a-card title="活动时间" class="mb-4">
    {{ dayjs.tz(activityDetail.startTime).format("YYYY年MM月DD日 HH:mm") }}
    -
    {{ dayjs.tz(activityDetail.endTime).format("YYYY年MM月DD日 HH:mm") }}
  </a-card>
  <a-card>
    <a-button v-if="userActivityStatus.isRegistered" long size="large" @click="signUpActivity">
      报名活动
    </a-button>
    <a-button v-else long size="large" status="warning" @click="cancelSignUpActivity">
      取消报名
    </a-button>
  </a-card>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { onMounted, reactive } from 'vue'
import { Message } from '@arco-design/web-vue'
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
