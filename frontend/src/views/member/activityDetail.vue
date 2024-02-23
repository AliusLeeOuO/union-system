<script setup lang="ts">
import dayjs from "dayjs"
import useMemberApi from "@/api/memberApi"
import { reactive,onMounted } from "vue"
import { Message } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import { useRoute } from "vue-router"

const memberApi = useMemberApi()
const route = useRoute()

const activityDetail =reactive({
  title: "",
  description: "",
  registrationCount: 0,
  maxParticipants: 0,
  location: "",
  startTime: "",
  endTime: "",
  activityTypeName: ""
})

const activityId = Number(route.params.id)

// 报名活动
const signUpActivity = async () => {
  await handleXhrResponse(() => memberApi.activityRegister(activityId), Message)
  Message.success("报名成功")
  await getActivityDetail(activityId)
}

// 取消报名
const cancelSignUpActivity = async () => {
  await handleXhrResponse(() => memberApi.activityCancel(activityId), Message)
  Message.success("取消报名成功")
  await getActivityDetail(activityId)
}

const getActivityDetail = async (activityId: number) => {
  const { data } = await handleXhrResponse(() => memberApi.activityDetail(activityId), Message)
  activityDetail.title = data.data.title
  activityDetail.description = data.data.description
  activityDetail.registrationCount = data.data.registrationCount
  activityDetail.maxParticipants = data.data.maxParticipants
  activityDetail.location = data.data.location
  activityDetail.startTime = data.data.startTime
  activityDetail.endTime = data.data.endTime
  activityDetail.activityTypeName = data.data.activityTypeName
}

onMounted(async () => {
  const activityId = Number(route.params.id)
  await getActivityDetail(activityId)
})
</script>

<template>
  <div>
    <h1>活动详情</h1>
  </div>
  <div class="activity-detail-content">
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">活动名称：</div>
      <div class="activity-detail-item-content">{{ activityDetail.title }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">活动描述：</div>
      <div class="activity-detail-item-content">{{ activityDetail.description }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">活动类型：</div>
      <div class="activity-detail-item-content">{{ activityDetail.activityTypeName }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">报名人数：</div>
      <div class="activity-detail-item-content">{{ activityDetail.registrationCount }}/{{ activityDetail.maxParticipants }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">活动地址：</div>
      <div class="activity-detail-item-content">{{ activityDetail.location }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="activity-detail-item-title">活动时间：</div>
      <div class="activity-detail-item-content">{{ dayjs(activityDetail.startTime).format("YYYY年MM月DD日 HH:mm") }} -
        {{ dayjs(activityDetail.endTime).format("YYYY年MM月DD日 HH:mm") }}
      </div>
    </div>
  </div>
  <div class="activity-action">
    <a-button @click="signUpActivity">报名活动</a-button>
    <a-button @click="cancelSignUpActivity">取消报名</a-button>
  </div>
</template>

<style scoped lang="less">

</style>