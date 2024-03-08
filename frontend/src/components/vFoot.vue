<template>
  <footer>
    <p>Copyright &copy; 2023 {{ pkg.author }} All Rights Reserved. Mail: {{ pkg.email }}</p>
    <p>
      页面版本v{{ pkg.version }}-{{ buildDate }}
      <a-link href="https://beian.miit.gov.cn/" @click="toMIIT">
        桂ICP备2022003399号-1
      </a-link>
      <router-link to="/openSourceLicense" custom v-slot="{ navigate }">
        <a-link @click="navigate">开源软件许可协议</a-link>
      </router-link>
    </p>
  </footer>
</template>

<script lang="ts" setup>
import pkg from "../../package.json"
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const attribute = parseInt(document.documentElement.getAttribute("data-build-timestamp")!)
const buildDate = dayjs.tz(attribute).format("YYYYMMDD")


function toMIIT(event: MouseEvent) {
  //@ts-ignore
  const toHref = event.target!.href as string
  window.open(toHref, "_blank")
  event.preventDefault()
}
</script>

<style lang="less" scoped>
footer {
  text-align: center;
  padding: 20px;
}
</style>
