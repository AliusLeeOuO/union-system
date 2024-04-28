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
    会员活动
  </a-typography-title>
  <a-space>
    <router-link to="/member/activity/plaza" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">活动广场</a-button>
    </router-link>
    <router-link to="/member/activity/my" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">我的活动</a-button>
    </router-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
// 面包屑
import type { BreadcrumbRoute } from "@arco-design/web-vue"

const routes: BreadcrumbRoute[] = [
  {
    path: "/member/activity",
    label: "活动"
  }
]
</script>
