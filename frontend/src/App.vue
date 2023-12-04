<template>
  <RouterView />
</template>
<script setup lang="ts">
import { RouterView } from "vue-router"
import { useDark } from "@vueuse/core"

useDark({
  selector: "body",
  attribute: "arco-theme",
  valueDark: "dark",
  valueLight: ""
})
</script>
<style lang="less" scoped>

</style>
