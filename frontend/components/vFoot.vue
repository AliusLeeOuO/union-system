<template>
  <footer>
    <p>Copyright &copy; {{ buildYear }} {{ pkg.author }} All Rights Reserved. Mail: {{ pkg.email }}</p>
    <client-only>
      <p>
        页面版本v{{ pkg.version }}-dev{{ buildDate }}
        <a-link href="https://beian.miit.gov.cn/" @click="toMIIT">
          桂ICP备2022003399号-1
        </a-link>
        <nuxt-link to="/openSourceLicense" custom v-slot="{ navigate }">
          <a-link @click="navigate">开源软件许可协议</a-link>
        </nuxt-link>
      </p>
    </client-only>
  </footer>
</template>

<script lang="ts" setup>
import pkg from "../package.json"
import dayjs from "dayjs"

const attribute = parseInt(document.documentElement.getAttribute("data-build-timestamp")!)
const buildYear = dayjs(attribute).format("YYYY")
const buildDate = dayjs(attribute).format("YYYYMMDD")


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
