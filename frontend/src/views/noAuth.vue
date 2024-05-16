<template>
  <div class="flex items-center justify-center">
    <h1 class="inline-block">
      Error 权限错误
    </h1>
    <h2>状态：您无权访问本页面 No Authorization</h2>
  </div>
</template>

<style scoped lang="less">
body[arco-theme="dark"] {
  div {
    h1 {
      border-right: 1px solid rgba(255, 255, 255, 0.3);
    }
  }
}

div {
  height: 100%;
  color: var(--color-text-1);

  h1 {
    border-right: 1px solid rgba(0, 0, 0, 0.3);
    margin: 0 20px 0 0;
    padding: 10px 23px 10px 0;
    font-size: 24px;
    font-weight: 500;
    vertical-align: top;
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
