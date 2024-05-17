<template>
  <header class="header-pc flex justify-between flex-items-center">
    <div class="header-left">
      <div class="logo flex cursor-pointer justify-center flex-items-center" @click="toIndex">
        <img src="@/assets/images/logo.png" alt="logo">
        <span>工会管理系统</span>
      </div>
    </div>
    <div class="header-right h-full flex justify-end gap-4 flex-items-center">
      <router-link
        v-if="userStore.userInfo.userRole === roles.USER" v-slot="{ navigate }" to="/member/notification"
        custom
      >
        <a-badge :count="notificationStore.notificationCount" :offset="[-20, -2]" @click="navigate">
          <div class="header-component-block h-90% flex cursor-pointer flex-items-center font-size-6 transition">
            <span class="mr-1 font-size-4">通知</span>
            <icon-notification />
          </div>
        </a-badge>
      </router-link>
      <a-dropdown>
        <div class="header-component-block h-90% flex cursor-pointer flex-items-center font-size-6 transition">
          <icon-sun />
        </div>
        <template #content>
          <a-doption @click="setTheme('system')">
            跟随系统
          </a-doption>
          <a-doption @click="setTheme('light')">
            亮色模式
          </a-doption>
          <a-doption @click="setTheme('dark')">
            暗色模式
          </a-doption>
        </template>
      </a-dropdown>
      <div
        v-if="userStore.isUserLoggedIn"
        v-click-outside:[dropdownRef]="handleClickOutside"
        class="h-90% flex cursor-pointer justify-center gap-2 flex-items-center"
        @click="openPersonInfo = !openPersonInfo"
      >
        {{ userStore.userInfo.userName }}
        <a-tag>{{ userStore.getUserRoleName }}</a-tag>
      </div>
      <div v-else class="h-90% flex cursor-pointer justify-center gap-2 flex-items-center">
        <a-button @click="toLogin">
          登录
        </a-button>
      </div>
    </div>
    <div v-if="openPersonInfo && userStore.isUserLoggedIn" ref="dropdownRef" class="header-pc-person-info absolute z-99 w-70 overflow-hidden">
      <div class="header-pc-person-info-text">
        {{ userStore.userInfo.userName }}
      </div>
      <div class="header-pc-person-info-button flex justify-end flex-items-center p-2">
        <a-space>
          <a-button @click="toUserIndex">
            用户中心
          </a-button>
          <a-button status="danger" @click="logout">
            退出登录
          </a-button>
        </a-space>
      </div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Message } from '@arco-design/web-vue'
import { useDark } from '@vueuse/core'
import { useUserStore } from '@/stores/user'
import { useNotificationStore } from '@/stores/notification'
import { handleXhrResponse } from '@/api'
import useUserApi from '@/api/userApi'
import { roles } from '@/router'

const isDark = useDark()
const router = useRouter()

// PC端个人信息
const userStore = useUserStore()
const notificationStore = useNotificationStore()
const dropdownRef = ref<HTMLElement | null>(null)
const openPersonInfo = ref(false)

function handleClickOutside(e: MouseEvent) {
  // 点击外部关闭个人信息
  if (dropdownRef.value && !dropdownRef.value.contains(e.target as HTMLElement)) {
    openPersonInfo.value = false
  }
}

// 跳转到用户个人中心
async function toUserIndex() {
  await router.push('/user')
  // 关闭个人信息
  openPersonInfo.value = false
}

// 退出登录
const userApi = useUserApi()

async function logout() {
  try {
    await handleXhrResponse(() => userApi.logout(), Message)
    userStore.clearUserInfo()
    await router.push('/login')
  }
  catch (e) {
    console.log(e)
  }
}

async function toLogin() {
  await router.push('/login')
}

// 根据角色跳转首页
async function toIndex() {
  if (userStore.isUserLoggedIn) {
    if (userStore.userInfo.userRole === roles.ADMIN) {
      await router.push('/admin/index')
    }
    else if (userStore.userInfo.userRole === roles.USER) {
      await router.push('/member/index')
    }
  }
  else {
    await router.push('/index')
  }
}

onMounted(async () => {
  await userStore.fetchPermission()
})

function setTheme(theme: 'system' | 'light' | 'dark') {
  switch (theme) {
    case 'system':
      isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
      break
    case 'light':
      isDark.value = false
      break
    case 'dark':
      isDark.value = true
      break
  }
}
</script>

<style lang="less" scoped>
@import "../assets/variable.less";

body[arco-theme="dark"] {
  .header-pc {
    border-bottom: 1px solid @dark-mode-border-color;

    .header-pc-person-info {
      .header-pc-person-info-text {
        background-color: #232323;
      }

      .header-pc-person-info-button {
        background-color: #424242;
      }
    }
  }
}

.header-pc {
  padding: 0 10px;
  height: @header-height;
  border-bottom: 1px solid @border-color;
  background-color: #fff;

  .header-left {
    min-width: 100px;

    .logo {
      gap: 5px;

      img {
        height: 35px;
      }
    }
  }

  .header-pc-person-info {
    right: 10px;
    top: 70px;
    background-color: #fff;
    color: rgb(var(--color-text-1));
    border-radius: 5px;
    animation: show-person-info 0.2s ease-in-out;

    .header-pc-person-info-text {
      padding: 10px;
      color: rgb(var(--color-text-1));
    }

    .header-pc-person-info-button {
      background-color: #eee;
    }
  }
}

.header-right {
  .header-component-block {
    &:hover {
      color: rgb(var(--primary-6));
    }
  }
}

body[arco-theme='dark'] {
  header {
    background-color: #232324;
  }
}
</style>
