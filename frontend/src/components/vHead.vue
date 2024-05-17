<template>
  <header class="header-pc flex justify-between flex-items-center">
    <div class="header-left">
      <div class="logo flex cursor-pointer justify-center flex-items-center" @click="toIndex">
        <img src="@/assets/images/logo.png" alt="logo">
        <span>工会管理系统</span>
      </div>
    </div>
    <div class="header-right">
      <router-link v-if="userStore.userInfo.userRole === roles.USER" v-slot="{ navigate }" to="/member/notification"
        custom>
        <a-badge :count="notificationStore.notificationCount" :offset="[-20, -2]" @click="navigate">
          <div class="header-component-block">
            <span>通知</span>
            <icon-notification />
          </div>
        </a-badge>
      </router-link>
      <a-dropdown>
        <div class="header-component-block">
          <span>配色模式</span>
          <icon-sun />
        </div>
        <template #content>
          <a-doption>跟随系统</a-doption>
          <a-doption>亮色模式</a-doption>
          <a-doption>暗色模式</a-doption>
        </template>
      </a-dropdown>
      <div v-if="userStore.isUserLoggedIn" v-click-outside:[dropdownRef]="handleClickOutside" class="user-info"
        @click="openPersonInfo = !openPersonInfo">
        {{ userStore.userInfo.userName }}
        <a-tag>{{ userStore.getUserRoleName }}</a-tag>
      </div>
      <div v-else class="user-info">
        <a-button @click="toLogin">
          登录
        </a-button>
      </div>
    </div>
    <div v-if="openPersonInfo && userStore.isUserLoggedIn" ref="dropdownRef" class="header-pc-person-info">
      <div class="header-pc-person-info-text">
        {{ userStore.userInfo.userName }}
      </div>
      <div class="header-pc-person-info-button">
        <a-button @click="toUserIndex">
          查看
        </a-button>
        <a-button status="danger" @click="logout">
          退出登录
        </a-button>
      </div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Message } from '@arco-design/web-vue'
import { useUserStore } from '@/stores/user'
import { useNotificationStore } from '@/stores/notification'
import { handleXhrResponse } from '@/api'
import useUserApi from '@/api/userApi'
import { roles } from '@/router'

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
</script>

<style lang="less" scoped>
@import "../assets/variable.less";

body[arco-theme="dark"] {
  .header-pc {
    border-bottom: 1px solid #424242;

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
  border-bottom: 1px solid #f0f0f0;

  .header-left {
    min-width: 100px;

    .logo {
      gap: 5px;

      img {
        height: 35px;
      }
    }
  }

  nav {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;

    .nav-item {
      color: rgb(78, 89, 105);
      text-decoration: none;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      position: relative;
      margin-left: 12px;

      &>div {
        padding: 5px 10px;

        &::before {
          content: "";
          position: absolute;
          left: 0;
          right: 0;
          bottom: 0;
          height: 3px;
          width: calc(100% - 20px);
          background-color: transparent;
          transition: all 0.3s;
          margin: auto;
        }
      }

      &:hover>div {
        background-color: #F2F3F5;
      }
    }

    .router-link-active {
      &>div {
        color: rgb(22, 93, 255);

        &:hover {
          background-color: #F2F3F5;
        }

        &::before {
          background-color: #165DFF;
        }
      }
    }
  }

  .header-pc-person-info {
    position: absolute;
    right: 10px;
    top: 70px;
    z-index: 99;
    background-color: #fff;
    color: rgb(var(--color-text-1));
    border-radius: 5px;
    width: 320px;
    overflow: hidden;
    animation: show-person-info 0.2s ease-in-out;

    .header-pc-person-info-text {
      padding: 10px;
      color: rgb(var(--color-text-1));
    }

    .header-pc-person-info-button {
      background-color: #eee;
      padding: 10px;
      display: flex;
      justify-content: flex-end;
      align-items: center;

      &>* {
        margin-left: 5px;
      }
    }
  }
}

.header-right {
  height: 100%;
  display: flex;
  justify-content: flex-end;
  align-items: center;

  .header-component-block {
    font-size: 20px;
    margin-right: 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    transition: color 0.3s;
    height: 90%;
    ;

    &:hover {
      color: rgb(var(--primary-6));
    }

    span {
      font-size: 14px;
      margin-right: 5px;
    }
  }

  .user-info {
    margin-right: 10px;
    height: 100%;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 5px;
  }
}

body[arco-theme='dark'] {
  header {
    background-color: #232324;
  }

  .header-pc {
    nav {
      flex: 1;

      .nav-item {
        color: rgb(201, 205, 212);

        &:hover>div {
          background-color: #2C2C2D;
        }
      }

      .router-link-active {
        &>div {
          color: rgb(255, 255, 255);

          &:hover {
            background-color: #2C2C2D;
          }

          &::before {
            background-color: rgb(22, 93, 255);
          }
        }
      }
    }
  }
}
</style>
