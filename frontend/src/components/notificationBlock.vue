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
        <a-tag>管理员 root</a-tag>
        {{ dayjs(props.createTime).format("YYYY年MM月DD日 HH:mm:ss") }}
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
import { ref, watchEffect } from "vue"
import dayjs from "dayjs"

const props = defineProps<{
  title: string
  createTime: string
  readStatus: boolean
}>()

const notificationContentShow = ref(false)
// 使用HTMLElement类型断言来初始化notificationContent
const notificationContent = ref<HTMLElement | null>(null)
const contentHeight = ref("0")

function openNotificationContent() {
  notificationContentShow.value = true
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
