<template>
  <div
    class="notification-block"
    :class="{
      'notification-block-show': notificationContentShow,
      'notification-block-read': props.readStatus,
    }"
    @click="openNotificationContent"
  >
    <div class="notification-top">
      <div class="notification-title">
        {{ props.title }}
      </div>
      <div class="notification-right">
        <a-tag>{{ getRoleName(props.senderRole) }} {{ senderUsername }}</a-tag>
        {{ dayjs.tz(props.createTime).format('YYYY年MM月DD日 HH:mm:ss') }}
      </div>
    </div>
    <div ref="notificationContent" class="notification-content" :style="{ height: contentHeight }">
      <div class="notification-content-show">
        <p>
          <slot name="content" />
        </p>
        <a-button long size="large" @click.stop="closeNotificationContent">
          关闭
        </a-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineEmits, defineProps, ref, watchEffect } from 'vue'
import dayjs from 'dayjs'
import { Message } from '@arco-design/web-vue'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useMemberApi from '@/api/memberApi'
import { getRoleName } from '@/utils/roleHelper'

const props = defineProps<{
  id: number
  title: string
  createTime: string
  readStatus: boolean
  senderRole: number
  senderUsername: string
}>()
const emit = defineEmits(['updateList'])
dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

const memberApi = useMemberApi()

const notificationContentShow = ref(false)
// 使用HTMLElement类型断言来初始化notificationContent
const notificationContent = ref<HTMLElement | null>(null)
const contentHeight = ref('0')

function openNotificationContent() {
  notificationContentShow.value = true

  if (!props.readStatus) {
    fetchRead(props.id)
    emit('updateList')
  }
}

function closeNotificationContent() {
  notificationContentShow.value = false
}

watchEffect(() => {
  if (notificationContent.value && notificationContentShow.value) {
    // TypeScript现在知道notificationContent.value是一个HTMLElement，因此scrollHeight是有效的属性
    contentHeight.value = `${notificationContent.value.scrollHeight}px`
  }
  else {
    contentHeight.value = '0'
  }
})

async function fetchRead(notificationId: number) {
  await handleXhrResponse(
    () => memberApi.notificationRead(notificationId),
    Message
  )
}
</script>

<style scoped lang="less">
@import "@/assets/variable.less";

body[arco-theme="dark"] {
  .notification-block {
    background-color: @dark-mode-bg;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

    &.notification-block-read {
      color: #8c8c8c;
    }
  }
}

.notification-block {
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

  .notification-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;

    .notification-title {
      font-size: 20px;
    }

    .notification-right {
      font-size: 1rem;
      display: flex;
      align-items: center;
      gap: 10px;
    }
  }

  .notification-content {
    font-size: 16px;
    height: 0;
    overflow: hidden;
    transition: height 0.3s;

    .notification-content-show {
      p {
        margin: 20px 0;
        line-height: 1.5;
      }
    }
  }

  .notification-content-show {
    height: auto;
  }
}

.notification-block-show {
  cursor: inherit;
}
</style>
