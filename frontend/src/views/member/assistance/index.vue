<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{route, paths}">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <a-typography-title :heading="2">
    帮助
  </a-typography-title>
  <a-space>
    <router-link to="/member/assistance/myAssistance" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">我的援助</a-button>
    </router-link>
    <router-link to="/member/assistance/newAssistance" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">新建援助</a-button>
    </router-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import type { BreadcrumbRoute } from "@arco-design/web-vue"
// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/member/assistance",
    label: "帮助"
  }
]
</script>
