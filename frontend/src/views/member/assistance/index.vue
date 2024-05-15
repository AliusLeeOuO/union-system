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
    <custom-route-link to="/member/assistance/myAssistance">我的援助</custom-route-link>
    <custom-route-link to="/member/assistance/newAssistance">新建援助</custom-route-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import type { BreadcrumbRoute } from "@arco-design/web-vue"
import customRouteLink from "@/components/customRouteLink.vue"
// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/member/assistance",
    label: "帮助"
  }
]
</script>
