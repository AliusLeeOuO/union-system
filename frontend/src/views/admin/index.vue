<template>
  <a-typography-title :heading="2">
    主页
  </a-typography-title>
  <a-typography-title :heading="5">
    欢迎回来！ {{ userStore.userInfo.userName }}
  </a-typography-title>
</template>
<script setup lang="ts">
import { useUserStore } from "@/stores/user"


const userStore = useUserStore()
</script>
<style scoped lang="less">

</style>