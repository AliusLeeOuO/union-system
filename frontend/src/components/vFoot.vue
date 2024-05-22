<template>
  <footer class="mb-2 text-center">
    <p>This project using MIT License. Author: {{ pkg.author }}. Mail: {{ pkg.email }}</p>
    <p>
      页面版本v{{ pkg.version }}-{{ buildDate }}
      <a-link href="https://beian.miit.gov.cn/" @click="toMIIT">
        桂ICP备2022003399号-2
      </a-link>
      <router-link v-slot="{ navigate }" to="/openSourceLicense" custom>
        <a-link @click="navigate">
          开源软件许可协议
        </a-link>
      </router-link>
    </p>
  </footer>
</template>

<script lang="ts" setup>
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import pkg from '../../package.json'

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

const attribute = Number.parseInt(document.documentElement.getAttribute('data-build-timestamp')!)
const buildDate = dayjs.tz(attribute).format('YYYYMMDD')

function toMIIT(event: MouseEvent) {
  // eslint-disable-next-line ts/ban-ts-comment
  // @ts-expect-error
  const toHref = event.target!.href as string
  window.open(toHref, '_blank')
  event.preventDefault()
}
</script>

<style lang="less" scoped>
footer {
  color: var(--color-text-1);
}
</style>
