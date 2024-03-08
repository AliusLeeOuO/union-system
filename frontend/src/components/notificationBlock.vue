<template>
  <div
    class="notification-block"
    :class="{
      'notification-block-show': notificationContentShow
    }"
    @click="openNotificationContent"
  >
    <div class="notification-top">
      <div class="notification-title">{{ props.title }}</div>
      <div class="notification-right">
        <a-tag>{{ getRoleName(props.senderRole) }} {{ senderUsername }}</a-tag>
        {{ dayjs.tz(props.createTime).format("YYYY年MM月DD日 HH:mm:ss") }}
      </div>
    </div>
    <div ref="notificationContent" class="notification-content" :style="{ height: contentHeight }">
      <div class="notification-content-show">
        <p>
          <slot name="content"></slot>
        </p>
        <a-button long size="large" @click.stop="closeNotificationContent">关闭</a-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watchEffect, defineProps, defineEmits } from "vue"
import dayjs from "dayjs"
import { handleXhrResponse } from "@/api"
import useMemberApi from "@/api/memberApi"
import { Message } from "@arco-design/web-vue"
import { getRoleName } from "@/utils/roleHelper"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const props = defineProps<{
  id: number
  title: string
  createTime: string
  readStatus: boolean
  senderRole: number
  senderUsername: string
}>()

const emit = defineEmits(["update-list"])

const memberApi = useMemberApi()

const notificationContentShow = ref(false)
// 使用HTMLElement类型断言来初始化notificationContent
const notificationContent = ref<HTMLElement | null>(null)
const contentHeight = ref("0")

function openNotificationContent() {
  notificationContentShow.value = true

  if (!props.readStatus) {
    fetchRead(props.id)
    emit("update-list")
  }
}

function closeNotificationContent() {
  notificationContentShow.value = false
}

watchEffect(() => {
  if (notificationContent.value && notificationContentShow.value) {
    // TypeScript现在知道notificationContent.value是一个HTMLElement，因此scrollHeight是有效的属性
    contentHeight.value = `${notificationContent.value.scrollHeight}px`
  } else {
    contentHeight.value = "0"
  }
})

const fetchRead = async (notificationId: number) => {
  await handleXhrResponse(
    () => memberApi.notificationRead(notificationId),
    Message
  )

}
</script>

<style scoped lang="less">
.notification-block {
  padding: 20px;
  border: 1px solid #ddd;
  margin-bottom: 20px;
  border-radius: 5px;
  cursor: pointer;

  .notification-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;

    .notification-title {
      font-size: 20px;
    }

    .notification-right {
      font-size: 14px;
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
