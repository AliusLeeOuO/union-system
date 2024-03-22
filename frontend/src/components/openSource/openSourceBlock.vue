<template>
  <div class="header">
    <span>{{ title }}</span>
    <a-link :href="link" target="_blank" class="link">{{ link }}</a-link>
  </div>
  <div class="content">
    <div>
      <slot></slot>
    </div>
  </div>
</template>
<script lang="ts" setup>
const props = defineProps<{
  title: string
  link: string
}>()
</script>
<style lang="less" scoped>
body[arco-theme="dark"] {
  .header {
    background-color: transparent;
    border-bottom: 1px solid #fff;
    border-radius: 0;
  }
}


.header {
  padding: 5px 10px;
  background-color: #eee;
  min-height: 40px;
  border-radius: 5px;
  overflow: hidden;
  font-size: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .link {
    text-align: right;
  }
}

.content {
  & > div {
    border-radius: 5px;
    padding: 10px;
    margin: 10px 0;
  }
}
</style>
