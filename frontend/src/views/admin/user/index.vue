<template>
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
