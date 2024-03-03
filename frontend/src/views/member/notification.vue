<template>
  <div class="notification-top">
    <h1>我的通知</h1>
    <a-button>一键已读</a-button>
  </div>
  <div class="notification-items">
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
    <notification-block />
  </div>
  <div class="pagination">
    <a-pagination :total="50" />
  </div>
</template>
<script setup lang="ts">

import NotificationBlock from "@/components/notificationBlock.vue"
</script>
<style scoped lang="less">
.notification-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 60px;

  h1 {
    font-size: 20px;
  }
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}
</style>