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
    系统管理
  </a-typography-title>
  <a-space>
    <custom-route-link to="/admin/management/loginLog">登录日志</custom-route-link>
    <custom-route-link to="/admin/management/adminActionLog">管理员操作日志</custom-route-link>
    <custom-route-link to="/admin/management/userActionLog">用户操作日志</custom-route-link>
    <custom-route-link to="/admin/management/systemInfo">系统信息</custom-route-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import { type BreadcrumbRoute } from "@arco-design/web-vue"
import customRouteLink from "@/components/customRouteLink.vue"

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/admin/management",
    label: "系统管理"
  }
]
</script>
