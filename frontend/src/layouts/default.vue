<template>
  <VHead />
  <div class="main w-screen flex">
    <a-menu
      v-if="userStore.isUserLoggedIn"
      class="h-full max-w-60"
      show-collapse-button
      auto-open-selected
      breakpoint="xl"
      :selected-keys="[currentRoute]"
    >
      <template v-for="item in navList(userStore.userPermissions)" :key="item.permission_node">
        <router-link
          v-if="!item.children || navList(item.children).length === 0" :to="item.permission_node"
          class="decoration-none"
        >
          <a-menu-item :key="item.permission_node">
            <template #icon>
              <component :is="renderIcon(item.icon)" />
            </template>
            {{ item.description }}
          </a-menu-item>
        </router-link>
        <a-sub-menu v-else :key="item.permission_node" class="asf">
          <template #icon>
            <component :is="renderIcon(item.icon)" />
          </template>
          <template #title>
            {{ item.description }}
          </template>
          <router-link
            v-for="menu in navList(item.children)" :key="menu.permission_node" :to="menu.permission_node"
            class="decoration-none"
          >
            <a-menu-item :key="menu.permission_node">
              <template #icon>
                <component :is="renderIcon(menu.icon)" />
              </template>
              {{ menu.description }}
            </a-menu-item>
          </router-link>
        </a-sub-menu>
      </template>
    </a-menu>
    <div class="main-container grid h-full flex-1 flex-col gap-2">
      <div class="route-title h-12 w-a flex flex-items-center pl-6 pr-6 font-size-5">
        {{ route.meta.title }}
      </div>
      <div class="main-route-container ml-2 mr-2 overflow-auto rounded-1 p-4">
        <div class="clearfix h-full min-w-sm w-full">
          <RouterView />
        </div>
      </div>
      <VFoot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, h } from 'vue'
import { useRoute } from 'vue-router'
import ArcoVueIcon from '@arco-design/web-vue/es/icon'
import { useUserStore } from '@/stores/user'
import VHead from '@/components/vHead.vue'
import VFoot from '@/components/vFoot.vue'
import type { permissionResponseData } from '@/api/userApi'

const userStore = useUserStore()
const route = useRoute()

const navList = (permissionList: permissionResponseData[]): permissionResponseData[] => permissionList.filter(item => !item.list_hidden).sort((a, b) => a.list_order - b.list_order)

const currentRoute = computed(() => route.path)

function renderIcon(icon: string) {
  // @ts-expect-error-next-line
  return h(ArcoVueIcon[icon])
}
</script>

<style scoped lang="less">
@import "../assets/variable.less";

.main {
  height: calc(100lvh - @header-height);

  .main-container {
    grid-template-rows: auto 1fr auto;

    .route-title {
      background-color: #fff;
      border-left: 1px solid @border-color;
      &::before {
        content: "";
        display: inline-block;
        width: 3px; /* 方块的宽度 */
        height: 18px; /* 方块的高度 */
        background-color: rgb(var(--primary-6)); /* 方块的颜色 */
        margin-right: 8px; /* 和文本之间的距离 */
        vertical-align: middle;
      }
    }
  }
}

body[arco-theme="dark"] {
  .main {
    .main-container {
      .route-title {
        background-color: @dark-mode-bg;
        border-left: 1px solid @dark-mode-border-color;
      }
    }
  }
}
</style>
