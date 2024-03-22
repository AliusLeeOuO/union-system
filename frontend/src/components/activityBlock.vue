<template>
  <router-link :to="props.path" class="activity-item">
    <div class="activity-item-title">{{ props.title }}</div>
    <div class="activity-item-description">{{ props.description }}</div>
    <div class="activity-item-persons">报名人数：{{ props.registrationCount }}/{{ props.maxParticipants }}</div>
    <div class="activity-item-location">
      地址：{{ props.location }}
      活动类型：{{ props.activityTypeName }}
    </div>
    <div class="activity-item-time">{{ dayjs.tz(props.startTime).format("YYYY年MM月DD日 HH:mm") }} -
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
  .activity-item {
    background-color: #232324;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
}
.activity-item {
  display: block;
  color: inherit;
  text-decoration: none;
  border-radius: 10px;
  background-color: #f5f5f5;
  padding: 20px;
  margin-top: 20px;
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  .activity-item-title {
    font-size: 20px;
    font-weight: bold;
  }

  .activity-item-description {
    margin-top: 10px;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
  }

  .activity-item-content {
    margin-top: 10px;
  }

  .activity-item-time {
    margin-top: 10px;
  }

  .activity-item-persons {
    margin-top: 10px;
  }

  .activity-item-location {
    margin-top: 10px;
  }
}
</style>