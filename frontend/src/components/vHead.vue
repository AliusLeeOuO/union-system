<template>
  <header class="header-pc">
    <div class="header-left">
      <div @click="toIndex" class="logo">工会管理系统</div>
    </div>
    <nav>
      <router-link :to="item.path" v-for="item in navIndex" :key="item.title"
                   class="nav-item">
        <div>
          {{ item.title }}
        </div>
      </router-link>
    </nav>
    <div class="header-right">
      <router-link to="/member/notification" custom v-slot="{ navigate }"
                   v-if="userStore.userInfo.userRole === roles.USER">
        <a-badge :count="notificationStore.notificationCount" :offset="[-20, -2]" @click="navigate">
          <div class="header-notification">
            <span>通知</span>
            <IconNotification />
          </div>
        </a-badge>
      </router-link>
      <div class="user-info" @click="openPersonInfo = !openPersonInfo" v-if="userStore.isUserLoggedIn"
           v-click-outside:[dropdownRef]="handleClickOutside">
        {{ userStore.userInfo.userName }}
        [ {{ userStore.getUserRoleName }} ]
      </div>
      <div class="user-info" v-else>
        <a-button @click="toLogin">登录</a-button>
      </div>
    </div>
    <div class="header-pc-person-info" v-if="openPersonInfo && userStore.isUserLoggedIn" ref="dropdownRef">
      <div class="header-pc-person-info-text">
        {{ userStore.userInfo.userName }}
      </div>
      <div class="header-pc-person-info-button">
        <a-button @click="toUserIndex">查看</a-button>
        <a-button status="danger" @click="logout">退出登录</a-button>
      </div>
    </div>
  </header>
  <header class="header-mobile">
    <router-link to="/index" custom v-slot="{ navigate }">
      <div @click="navigate" class="logo">工会管理系统</div>
    </router-link>
    <div class="burger-nav">
      <div class="burger-icon" @click="openMobileNav = true">
        <svg id="menu-icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
             x="0px" y="0px" viewBox="0 0 24 24">
          <line id="menu-line-top" class="menu-line" x1="1" y1="6" x2="23" y2="6" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
          <line id="menu-line-mid" class="menu-line" x1="1" y1="12" x2="23" y2="12" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
          <line id="menu-line-bot" class="menu-line" x1="1" y1="18" x2="23" y2="18" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
        </svg>
      </div>
    </div>
    <div class="mobile-nav" :class="{'open-mobile-nav': openMobileNav}">
      <div class="mobile-nav-top">
        <div class="nav-top-left"></div>
        <div class="nav-top-right">
          <div class="close-menu-icon" @click="openMobileNav = false">
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg"
                 x="0px" y="0px" viewBox="0 0 24 24">
              <line id="menu-line-top" class="menu-line" x1="1" y1="6" x2="23" y2="6" stroke-width="2.4"
                    vector-effect="non-scaling-stroke" data-svg-origin="12 6" style="transform-origin: 0 0;"
                    transform="matrix(-0.70711,-0.70711,0.70711,-0.70711,16.24266,24.72798)"></line>
              <line id="menu-line-bot" class="menu-line" x1="1" y1="18" x2="23" y2="18" stroke-width="2.4"
                    vector-effect="non-scaling-stroke" data-svg-origin="12 18" style="transform-origin: 0 0;"
                    transform="matrix(-0.70711,0.70711,-0.70711,-0.70711,33.2133,16.24266)"></line>
            </svg>
          </div>
        </div>
      </div>
      <div class="mobile-nav-main">
        <router-link :to="item.path" v-for="item in navIndex" :key="item.title" @click="openMobileNav = false"
                     class="mobile-nav-item">
          {{ item.title }}
        </router-link>
      </div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import { computed, reactive, ref } from "vue"
import { useRouter } from "vue-router"
import { useUserStore } from "@/stores/user"
import { useNotificationStore } from "@/stores/notification"
import { handleXhrResponse } from "@/api"
import useUserApi from "@/api/userApi"
import { Message } from "@arco-design/web-vue"
import { IconNotification } from "@arco-design/web-vue/es/icon"
import { roles } from "@/router"

//PC端个人信息
const userStore = useUserStore()
const notificationStore = useNotificationStore()
const dropdownRef = ref<HTMLElement | null>(null)
const openPersonInfo = ref(false)
const handleClickOutside = (e: MouseEvent) => {
  // 点击外部关闭个人信息
  if (dropdownRef.value && !dropdownRef.value.contains(e.target as HTMLElement)) {
    openPersonInfo.value = false
  }
}

// 跳转到用户个人中心
const toUserIndex = async () => {
  await router.push("/user")
  // 关闭个人信息
  openPersonInfo.value = false
}

// 退出登录
const userApi = useUserApi()
const logout = async () => {
  try {
    await handleXhrResponse(() => userApi.logout(), Message)
    userStore.clearUserInfo()
    await router.push("/login")
  } catch (e) {
    console.log(e)
  }
}

const router = useRouter()
const toLogin = async () => {
  await router.push("/login")
}

//手机端汉堡菜单
const openMobileNav = ref(false)


// nav列表数组
interface navList {
  title: string
  path: string
}

// 公共导航栏
const navList = reactive<navList[]>([
  {
    title: "首页",
    path: "/index"
  }
])
// 会员导航栏
const memberNavList = reactive<navList[]>([
  {
    title: "首页",
    path: "/member/index"
  },
  {
    title: "活动",
    path: "/member/activity"
  },
  {
    title: "帮助",
    path: "/member/assistance"
  },
  {
    title: "会费",
    path: "/member/fee"
  }
])
// 管理员导航栏
const adminNavList = reactive<navList[]>([
  {
    title: "首页",
    path: "/admin/index"
  },
  {
    title: "用户管理",
    path: "/admin/manageUser"
  },
  {
    title: "援助管理",
    path: "/admin/manageAssistance"
  },
  {
    title: "日志审计",
    path: "/admin/logView"
  }
])

// 监听用户登录状态，切换导航栏
const navIndex = computed(() => {
  if (userStore.isUserLoggedIn) {
    if (userStore.userInfo.userRole === roles.ADMIN) {
      return adminNavList
    } else if (userStore.userInfo.userRole === roles.USER) {
      return memberNavList
    }
  }
  return navList
})

// 根据角色跳转首页
const toIndex = async () => {
  if (userStore.isUserLoggedIn) {
    if (userStore.userInfo.userRole === roles.ADMIN) {
      await router.push("/admin/index")
    } else if (userStore.userInfo.userRole === roles.USER) {
      await router.push("/member/index")
    }
  } else {
    await router.push("/index")
  }
}

</script>

<style lang="less" scoped>
.header-pc {
  padding: 0 10px;
  height: 60px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  @media only screen and (max-width: 768px) {
    display: none;
  }

  .header-left {
    min-width: 100px;

    .logo {
      cursor: pointer;
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

      & > div {
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

      &:hover > div {
        background-color: #F2F3F5;
      }
    }

    .router-link-active {
      & > div {
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
      @media (prefers-color-scheme: dark) {
        background-color: #232323;
      }
    }

    .header-pc-person-info-button {
      background-color: #eee;
      padding: 10px;
      display: flex;
      justify-content: flex-end;
      align-items: center;

      & > * {
        margin-left: 5px;
      }

      // dark mode
      @media (prefers-color-scheme: dark) {
        background-color: #424242;
      }
    }
  }
}

.header-right {
  //min-width: 130px;
  height: 100%;
  display: flex;
  justify-content: flex-end;
  align-items: center;

  .header-notification {
    font-size: 20px;
    margin-right: 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    transition: color 0.3s;

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

  }
}


.header-mobile {
  padding: 0 10px;
  height: 60px;
  display: none;
  align-items: center;
  justify-content: space-between;
  @media only screen and (max-width: 768px) {
    display: flex;
  }

  .logo {
    min-width: 100px;
    cursor: pointer;
  }

  .burger-nav {
    display: flex;

    .darkmode-switch {
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;

      span {
        margin-right: 10px;
      }
    }

    .burger-icon {
      margin-left: 10px;
      width: 25px;
      height: 25px;
      cursor: pointer;

      #menu-icon {
        line {
          stroke: rgb(0, 0, 0);
        }
      }
    }
  }

  .mobile-nav {
    background-color: rgb(241, 241, 241);
    position: fixed;
    width: 100vw;
    height: 100vh;
    top: 0;
    left: 100vw;
    pointer-events: none;
    opacity: 0;
    transition: 0.3s ease-in-out;
    padding: 20px;

    .mobile-nav-top {
      height: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .nav-top-right {
        .close-menu-icon {
          height: 25px;
          width: 25px;
          cursor: pointer;

          svg {
            height: 100%;
            width: 100%;

            line {
              stroke: rgb(0, 0, 0);
            }
          }
        }
      }
    }

    .mobile-nav-main {
      margin-top: 10px;

      .mobile-nav-item {
        display: block;
        color: #000;
        text-decoration: none;
        font-size: 18px;
        margin: 10px 0;
      }
    }
  }

  .open-mobile-nav {
    opacity: 1;
    left: 0;
    pointer-events: inherit;
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

        &:hover > div {
          background-color: #2C2C2D;
        }
      }

      .router-link-active {
        & > div {
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

  .header-mobile {
    .burger-nav {
      .burger-icon {
        #menu-icon {
          line {
            stroke: rgb(255, 255, 255);
          }
        }
      }
    }

    .mobile-nav {
      background-color: #191919;

      .mobile-nav-top {
        .nav-top-right {
          .close-menu-icon {
            svg {
              line {
                stroke: #fff;
              }
            }
          }
        }
      }

      .mobile-nav-main {
        .mobile-nav-item {
          color: rgb(var(--color-text-1));
        }
      }
    }
  }
}

@keyframes show-person-info {
  0% {
    opacity: 0;
    transform: translateY(-10px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
