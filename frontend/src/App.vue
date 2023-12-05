<template>
  <RouterView />
</template>
<script setup lang="ts">
import { RouterView } from "vue-router"
import { useDark } from "@vueuse/core"
import { onMounted } from "vue"
import { useUserStore } from "@/stores/user"
import useUserApi from "@/api/userApi"

useDark({
  selector: "body",
  attribute: "arco-theme",
  valueDark: "dark",
  valueLight: ""
})

const userStore = useUserStore()
const userApi = useUserApi()
onMounted(async () => {
  if (userStore.isUserLoggedIn) {
    await userApi.getUserInfo()
  }
})
</script>
<style lang="less" scoped>

</style>
