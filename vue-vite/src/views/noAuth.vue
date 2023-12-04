<script setup lang="ts">

</script>

<template>
  <div>
    <h1>Error 权限错误</h1>
    <h2>状态：您无权访问本页面 No Authorization</h2>
  </div>
</template>

<style scoped lang="less">
div {
  height: calc(100vh - 150px);
  display: flex;
  flex: 1;
  justify-content: center;
  align-items: center;
  h1 {
    display: inline-block;
    border-right: 1px solid rgba(0, 0, 0, 0.3);
    margin: 0px 20px 0px 0px;
    padding: 10px 23px 10px 0px;
    font-size: 24px;
    font-weight: 500;
    vertical-align: top;
    // darkmode下媒体查询 arco-theme
    @media (prefers-color-scheme: dark) {
      border-right: 1px solid rgba(255, 255, 255, 0.3);
    }
  }

  h2 {
    font-size: 14px;
    font-weight: normal;
    line-height: inherit;
    margin: 0;
    padding: 0;
  }
}

</style>