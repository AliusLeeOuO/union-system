<template>
  <div>
    <a-descriptions :data="data" title="CPU状态" size="large" :column="1" bordered />
  </div>
</template>
<script lang="ts" setup>
import { reactive } from "vue"

const data = reactive([
  {
    label: "型号",
    value: "Socrates"
  },
  {
    label: "核心数",
    value: "123-1234-1234"
  },
  {
    label: "缓存",
    value: "Beijing"
  },
  {
    label: "使用率",
    value: "BeijingBeijingBeijingBeijingBeijingBeijing"
  },
  {
    label: "空闲率",
    value: "Yingdu Building, Zhichun Road, Beijing"
  }
])
</script>
