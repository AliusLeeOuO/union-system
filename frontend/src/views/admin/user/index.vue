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
    用户管理
  </a-typography-title>
  <a-space>
    <custom-route-link to="/admin/user/manage">
      用户管理
    </custom-route-link>
    <custom-route-link to="/admin/user/invitationCode">
      邀请码管理
    </custom-route-link>
  </a-space>
  <div class="mb-3 mt-4">
    <router-view />
  </div>
</template>

<script setup lang="ts">
import type { BreadcrumbRoute } from '@arco-design/web-vue'
import customRouteLink from '@/components/customRouteLink.vue'

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: '/admin/user',
    label: '用户管理'
  }
]
</script>
