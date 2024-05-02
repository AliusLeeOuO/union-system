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
    <router-link to="/admin/fee/feeSetting" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">会费标准管理</a-button>
    </router-link>
    <router-link to="/admin/fee/registeredMember" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">已注册会员管理</a-button>
    </router-link>
    <router-link to="/admin/fee/nonRegisteredMember" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">未注册会员管理</a-button>
    </router-link>
  </a-space>
  <div class="mt-4 mb-3">
    <router-view />
  </div>
</template>
<script setup lang="ts">
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
