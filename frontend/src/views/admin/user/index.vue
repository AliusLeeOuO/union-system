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
    用户管理
  </a-typography-title>
  <a-space>
    <router-link to="/admin/user/manage" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">用户管理</a-button>
    </router-link>
    <router-link to="/admin/user/invitationCode" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">邀请码管理</a-button>
    </router-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import { type BreadcrumbRoute } from "@arco-design/web-vue"



// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/admin/user",
    label: "用户管理"
  }
]




</script>
