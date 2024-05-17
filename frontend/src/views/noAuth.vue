<template>
  <div class="h-full flex items-center justify-center">
    <h1 class="inline-block pr-6 vertical-top font-size-7 font-500">
      Error 权限错误
    </h1>
    <h2 class="ml-6 p-0 font-size-4 font-normal line-height-none">
      状态：您无权访问本页面 No Authorization
    </h2>
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
  color: var(--color-text-1);

  h1 {
    border-right: 1px solid rgba(0, 0, 0, 0.3);
  }
}
</style>
