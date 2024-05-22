<template>
  <div class="header flex justify-between flex-items-center overflow-hidden">
    <span>{{ props.title }}</span>
    <a-link :href="props.link" target="_blank" class="text-right">
      {{ props.link }}
    </a-link>
  </div>
  <div class="content">
    <div>
      <slot />
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
  font-size: 20px;
}

.content {
  & > div {
    border-radius: 5px;
    padding: 10px;
    margin: 10px 0;
  }
}
</style>
