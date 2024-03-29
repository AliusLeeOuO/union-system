<template>
  <div>
    <a-descriptions :data="data" title="CPU状态" size="large" :column="1" bordered />
  </div>
</template>
<script lang="ts" setup>
import { onMounted, onUnmounted, reactive } from "vue"
import dayjs from "dayjs"
import { useUserStore } from "@/stores/user"

const data = reactive([
  {
    label: "型号",
    value: "Socrates"
  },
  {
    label: "核心数",
    value: "123-1234-1234"
  },
  {
    label: "缓存",
    value: "Beijing"
  },
  {
    label: "使用率",
    value: "BeijingBeijingBeijingBeijingBeijingBeijing"
  },
  {
    label: "空闲率",
    value: "Yingdu Building, Zhichun Road, Beijing"
  }
])

let ws: WebSocket
const userStore = useUserStore()

function connect() {
  ws = new WebSocket(`ws://localhost:9999/admin/management/deviceInfo?AuthorizationQuery=Bearer%20${userStore.userInfo.token}`)
  let wsPingTime = dayjs().unix()
  // let wsPingInterval: number
  let wsConnectCheck: number


  ws.onopen = () => {
    console.log("WebSocket connected")

    clearInterval(wsConnectCheck)

    ws.send(JSON.stringify({
      "topic": "subscribe",
      "content": "ping"
    }))


    wsConnectCheck = setInterval(() => {
      // 10秒内未收到pong消息，重连
      if (dayjs().unix() - wsPingTime > 10) {
        console.log("WebSocket reconnecting")
        ws.close()
        setTimeout(function () {
          connect()
        }, 1000)
      }
    }, 1000)
  }

  ws.onmessage = (e: MessageEvent) => {
    console.log(e)
    const data = JSON.parse(e.data)
    switch (data.topic) {
      case "ping":
        wsPingTime = dayjs().unix()
        break
      default:
        console.log(data)
        break
    }
  }
  ws.onclose = () => {
    console.log("连接关闭")
    // clearInterval(wsPingInterval)
    clearInterval(wsConnectCheck)
  }
  ws.onerror = () => {
    console.log("连接错误")
  }
}

onMounted(() => {
  connect()
})
onUnmounted(() => {
  ws.close()
})
</script>
