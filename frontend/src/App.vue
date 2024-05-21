<template>
  <RouterView />
</template>

<script setup lang="ts">
import { RouterView } from 'vue-router'
import { useDark } from '@vueuse/core'
import { onMounted } from 'vue'
import { Message } from '@arco-design/web-vue'
import { useUserStore } from '@/stores/user'
import useUserApi from '@/api/userApi'
import { handleXhrResponse } from '@/api'

useDark({
  selector: 'body',
  attribute: 'arco-theme',
  valueDark: 'dark',
  valueLight: ''
})

const userStore = useUserStore()
const userApi = useUserApi()
onMounted(async () => {
  if (userStore.isUserLoggedIn) {
    const { data } = await handleXhrResponse(() => userApi.getUserInfo(), Message)
    userStore.userInfo.userName = data.data.username
    userStore.userInfo.userId = data.data.userID
    userStore.userInfo.userRole = data.data.role
    userStore.userInfo.phone = data.data.phone
    userStore.userInfo.email = data.data.email
    userStore.userInfo.accountType = data.data.account_type
  }
})
</script>
