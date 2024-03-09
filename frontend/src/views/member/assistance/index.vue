<template>
  <a-typography-title :heading="2">
    帮助
  </a-typography-title>
  <a-space>
    <router-link to="/member/assistance/myAssistance" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">我的援助</a-button>
    </router-link>
    <router-link to="/member/assistance/newAssistance" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">新建援助</a-button>
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