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
    <router-link to="/admin/log/loginLog" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">登录日志</a-button>
    </router-link>
    <router-link to="/admin/log/adminActionLog" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">管理员操作日志</a-button>
    </router-link>
    <router-link to="/admin/log/userActionLog" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">用户操作日志</a-button>
    </router-link>
    <router-link to="/admin/log/systemInfo" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">系统信息</a-button>
    </router-link>
  </a-space>
  <div class="router-container">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import { type BreadcrumbRoute } from "@arco-design/web-vue"

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/admin/log",
    label: "系统管理"
  }
]
</script>
<style scoped lang="less">
.router-container {
  margin: 20px 0;
}
</style>