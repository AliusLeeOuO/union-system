<template>
  <a-typography-title :heading="2">
    会员活动
  </a-typography-title>
  <a-space>
    <router-link to="/member/activity/plaza" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">活动广场</a-button>
    </router-link>
    <router-link to="/member/activity/my" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">我的活动</a-button>
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