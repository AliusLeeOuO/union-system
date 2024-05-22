<template>
  <a-card class="block cursor-pointer" @click="navigate">
    <div class="text-xl font-bold">
      {{ props.title }}
    </div>
    <div class="display-box line-clamp-3 mt-2.5 overflow-hidden text-ellipsis">
      {{ props.description }}
    </div>
    <div class="mt-2.5">
      报名人数：{{ props.registrationCount }}/{{ props.maxParticipants }}
    </div>
    <div class="mt-2.5">
      地址：{{ props.location }}
      活动类型：{{ props.activityTypeName }}
    </div>
    <div class="mt-2.5">
      {{ dayjs.tz(props.startTime).format('YYYY年MM月DD日 HH:mm') }} -
      {{ dayjs.tz(props.endTime).format('YYYY年MM月DD日 HH:mm') }}
    </div>
  </a-card>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { defineEmits, defineProps } from 'vue'

const props = defineProps<{
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

const emits = defineEmits(['checkDetail'])
dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

function navigate() {
  emits('checkDetail', props.activityId)
}
</script>

<style scoped lang="less">
@import "@/assets/variable.less";
body[arco-theme="dark"] {
  .block {
    background-color: @dark-mode-bg;
    box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
  }
}
</style>
