<template>
  <a-typography-title :heading="2">
    日志审计
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
  </a-space>
  <div class="router-container">
    <router-view />
  </div>
</template>
<script setup lang="ts">

</script>
<style scoped lang="less">
.router-container {
  margin: 20px 0;
}
</style>