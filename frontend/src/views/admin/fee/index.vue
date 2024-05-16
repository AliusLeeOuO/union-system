<template>
  <div class="mb-3 mt-4">
    <router-view />
  </div>
</template>

<script setup lang="ts">
// 面包屑
const routes = [
  {
    path: '/admin/fee',
    label: '会费管理'
  }
]
</script>

<style scoped lang="less">

</style>
