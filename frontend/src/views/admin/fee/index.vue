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
    会费管理
  </a-typography-title>
  <a-space>
    <custom-route-link to="/admin/fee/feeSetting">会费标准管理</custom-route-link>
    <custom-route-link to="/admin/fee/registeredMember">已注册会员管理</custom-route-link>
    <custom-route-link to="/admin/fee/nonRegisteredMember">未注册会员管理</custom-route-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import customRouteLink from "@/components/customRouteLink.vue"
// 面包屑
const routes = [
  {
    path: "/admin/fee",
    label: "会费管理"
  }
]
</script>
<style scoped lang="less">

</style>
