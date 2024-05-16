<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{ route }">
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
    <custom-route-link to="/member/activity/plaza">
      活动广场
    </custom-route-link>
    <custom-route-link to="/member/activity/my">
      我的活动
    </custom-route-link>
  </a-space>
  <div class="mb-3 mt-4">
    <router-view />
  </div>
</template>

<script setup lang="ts">
// 面包屑
import type { BreadcrumbRoute } from '@arco-design/web-vue'
import customRouteLink from '@/components/customRouteLink.vue'

const routes: BreadcrumbRoute[] = [
  {
    path: '/member/activity',
    label: '活动'
  }
]
</script>
