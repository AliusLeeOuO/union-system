<template>
  <div class="of-hidden">
    <a-card class="mb-4">
      <div class="description-block grid gap-xl">
        <div class="w-full">
          <a-typography-title :heading="4">
            CPU信息
          </a-typography-title>
          <a-descriptions :data="cpuInfoData" size="large" :column="1" bordered />
        </div>
        <div class="h-sm w-full">
          <VChart :theme="chartTheme" :option="cpuInfoOption" :autoresize="true" />
        </div>
      </div>
    </a-card>
    <a-card>
      <div class="description-block grid mb-4 gap-xl">
        <div class="w-full">
          <a-typography-title :heading="4">
            内存信息
          </a-typography-title>
          <a-descriptions class="description" :data="memInfoData" size="large" :column="1" bordered />
        </div>
        <div class="h-sm w-full">
          <VChart :theme="chartTheme" :option="memInfoOption" :autoresize="true" />
        </div>
      </div>
    </a-card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, onUnmounted, reactive, ref, watchEffect } from 'vue'
import dayjs from 'dayjs'
import type { DescData } from '@arco-design/web-vue'
import numeral from 'numeral'

import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { GaugeChart } from 'echarts/charts'
import { TooltipComponent } from 'echarts/components'
import type { EChartsOption } from 'echarts'
import VChart from 'vue-echarts'
import { useUserStore } from '@/stores/user'

use([
  TooltipComponent,
  GaugeChart,
  CanvasRenderer
])

// 为v-chart主题创建一个响应式引用
const chartTheme = ref('default') // 默认为明亮主题

watchEffect(() => {
  const theme = document.body.getAttribute('arco-theme')
  chartTheme.value = theme === 'dark' ? 'dark' : 'default' // 如果arco-theme为dark，则使用dark主题，否则使用默认主题
})

const cpuInfoOption = reactive<EChartsOption>({
  backgroundColor: 'transparent',
  series: [
    {
      name: 'CPU使用率',
      type: 'gauge',
      detail: {
        formatter: '{value}%'
      },
      data: [
        {
          value: 0,
          name: '使用率'
        }
      ]
    }
  ]
})

const memInfoOption = reactive<EChartsOption>({
  backgroundColor: 'transparent',
  series: [
    {
      name: '内存使用率',
      type: 'gauge',
      detail: {
        formatter: '{value}%'
      },
      data: [
        {
          value: 0,
          name: '使用率'
        }
      ]
    }
  ]
})

const cpuInfoData = reactive<DescData[]>([
  {
    label: '型号',
    value: '等待获取...'
  },
  {
    label: '核心数',
    value: '等待获取...'
  },
  {
    label: '缓存',
    value: '等待获取...'
  },
  {
    label: '使用率',
    value: '等待获取...'
  },
  {
    label: '空闲率',
    value: '等待获取...'
  }
])

const memInfoData = reactive<DescData[]>([
  {
    label: '总内存',
    value: '等待获取...'
  },
  {
    label: '已用内存',
    value: '等待获取...'
  },
  {
    label: '剩余内存',
    value: '等待获取...'
  },
  {
    label: '使用率',
    value: '等待获取...'
  }
])

interface cpuInfoContent {
  cores: number
  trends: number
  models: string
  cache: number
  usage: number
  idle: number
}

interface memInfoContent {
  free: number
  total: number
  usage: number
  used: number
}

let ws: WebSocket
const userStore = useUserStore()

function connect() {
  ws = new WebSocket(`ws://localhost:9999/admin/management/deviceInfo?AuthorizationQuery=Bearer%20${userStore.userInfo.token}`)
  let wsPingTime = dayjs().unix()
  // let wsPingInterval: number
  let wsConnectCheck: number

  ws.onopen = () => {
    console.log('WebSocket connected')

    clearInterval(wsConnectCheck)

    ws.send(JSON.stringify({
      topic: 'subscribe',
      content: 'ping'
    }))
    ws.send(JSON.stringify({
      topic: 'subscribe',
      content: 'cpuInfo'
    }))
    ws.send(JSON.stringify({
      topic: 'subscribe',
      content: 'memInfo'
    }))

    wsConnectCheck = setInterval(() => {
      // 10秒内未收到pong消息，重连
      if (dayjs().unix() - wsPingTime > 10) {
        console.log('WebSocket reconnecting')
        ws.close()
        setTimeout(() => {
          connect()
        }, 1000)
      }
    }, 1000)
  }

  ws.onmessage = (e: MessageEvent) => {
    const messageData = JSON.parse(e.data)
    switch (messageData.topic) {
      case 'ping':
        wsPingTime = dayjs().unix()
        break
      case 'cpuInfo': {
        const cpuInfoContent: cpuInfoContent = messageData.content.message
        cpuInfoData[0].value = cpuInfoContent.models
        cpuInfoData[1].value = cpuInfoContent.cores.toString()
        cpuInfoData[2].value = cpuInfoContent.cache.toString()
        cpuInfoData[3].value = `${cpuInfoContent.usage.toString()}%`
        cpuInfoData[4].value = `${cpuInfoContent.idle.toString()}%`;
        (cpuInfoOption.series as Array<{ data: Array<{ value: number }> }>)[0].data[0].value = cpuInfoContent.usage
        break
      }
      case 'memInfo': {
        const memInfoContent: memInfoContent = messageData.content.message
        memInfoData[0].value = `${numeral(memInfoContent.total / 1024 / 1024 / 1024).format('0.00')}GB`
        memInfoData[1].value = `${numeral(memInfoContent.used / 1024 / 1024 / 1024).format('0.00')}GB`
        memInfoData[2].value = `${numeral(memInfoContent.free / 1024 / 1024 / 1024).format('0.00')}GB`
        memInfoData[3].value = `${memInfoContent.usage.toString()}%`;
        (memInfoOption.series as Array<{ data: Array<{ value: number }> }>)[0].data[0].value = memInfoContent.usage
        break
      }
    }
  }
  ws.onclose = () => {
    console.log('连接关闭')
    clearInterval(wsConnectCheck)
  }
  ws.onerror = () => {
    console.log('连接错误')
  }
}

onMounted(() => {
  connect()
})
onUnmounted(() => {
  ws.close()
})
</script>

<style lang="less" scoped>
.description-block {
  grid-template-columns: 70% 30%;
}
</style>
