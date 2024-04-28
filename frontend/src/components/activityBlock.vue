<template>
  <router-link :to="props.path" class="block text-inherit no-underline rounded-lg bg-gray-100 p-5 mt-5 mb-5 cursor-pointer transition-all duration-300">
    <div class="text-xl font-bold">{{ props.title }}</div>
    <div class="mt-2.5 overflow-hidden text-ellipsis display-box line-clamp-3">{{ props.description }}</div>
    <div class="mt-2.5">报名人数：{{ props.registrationCount }}/{{ props.maxParticipants }}</div>
    <div class="mt-2.5">
      地址：{{ props.location }}
      活动类型：{{ props.activityTypeName }}
    </div>
    <div class="mt-2.5">{{ dayjs.tz(props.startTime).format("YYYY年MM月DD日 HH:mm") }} -
      {{ dayjs.tz(props.endTime).format("YYYY年MM月DD日 HH:mm") }}
    </div>
  </router-link>
</template>
<script setup lang="ts">
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const props = defineProps<{
  path: string
  activityId: number
  title: string
  description: string
  registrationCount: number
  maxParticipants: number
  location: string
  activityTypeName: string
  startTime: string
  endTime: string
}>()

</script>
<style scoped lang="less">
body[arco-theme="dark"] {
  .block {
    background-color: #232324;
    box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
  }
}
</style>
