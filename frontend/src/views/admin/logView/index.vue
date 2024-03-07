<template>
  <div>
    <h1>日志审计</h1>
  </div>
  <a-space>
    <router-link to="/admin/loginLogView" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">登录日志</a-button>
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