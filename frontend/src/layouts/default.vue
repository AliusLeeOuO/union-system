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
        <router-link v-if="!item.children || navList(item.children).length === 0" :to="item.permission_node">
          <a-menu-item :key="item.permission_node">
            <template #icon>
              <icon-apps />
            </template>
            {{ item.description }}
          </a-menu-item>
        </router-link>
        <a-sub-menu v-else :key="item.permission_node" class="asf">
          <template #icon>
            <icon-apps />
          </template>
          <template #title>
            {{ item.description }}
          </template>
          <router-link v-for="menu in navList(item.children)" :key="menu.permission_node" :to="menu.permission_node">
            <a-menu-item :key="menu.permission_node">
              <template #icon>
                <icon-apps />
              </template>
              {{ menu.description }}
            </a-menu-item>
          </router-link>
        </a-sub-menu>
      </template>
    </a-menu>
    <div class="main-container grid h-full flex-1 flex-col gap-2">
      <div class="h-12 w-a flex flex-items-center bg-#232324 pl-6 pr-6 font-size-5">
        {{ route.meta.title }}
      </div>
      <div class="ml-2 mr-2 overflow-auto rounded-1 bg-#232324 p-4">
        <div class="clearfix h-full min-w-sm w-full">
          <RouterView />
        </div>
      </div>
      <VFoot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import VHead from '@/components/vHead.vue'
import VFoot from '@/components/vFoot.vue'
import type { permissionResponseData } from '@/api/userApi'

const userStore = useUserStore()
const route = useRoute()

const navList = (permissionList: permissionResponseData[]): permissionResponseData[] => permissionList.filter(item => !item.list_hidden).sort((a, b) => a.list_order - b.list_order)

// const navList = computed((permissionList: permissionResponseData[]) => permissionList.filter(item => !item.list_hidden).sort((a, b) => a.list_order - b.list_order))
const currentRoute = computed(() => route.path)
</script>

<style scoped lang="less">
@import "../assets/variable.less";

.main {
  height: calc(100lvh - @header-height);

  .main-container {
    grid-template-rows: auto 1fr auto;
  }
}
</style>
