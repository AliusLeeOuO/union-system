<template>
  <div class="safe-area" :style="safeAreaStyle">
    <nuxt-layout>
      <nuxt-page />
    </nuxt-layout>
  </div>
</template>
<script lang="ts" setup>
import { useDark, useScreenSafeArea } from "@vueuse/core"

const {
  top,
  right,
  bottom,
  left
} = useScreenSafeArea()

useDark({
  selector: "body",
  attribute: "arco-theme",
  valueDark: "dark",
  valueLight: ""
})

// 添加边距到safe-area
const safeAreaStyle = {
  paddingTop: `${top.value}px`,
  paddingRight: `${right.value}px`,
  paddingBottom: `${bottom.value}px`,
  paddingLeft: `${left.value}px`
}
</script>
<style lang="less">
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

//dark mode
html[arco-theme='dark'], body[arco-theme='dark'] {
  background-color: #111111;
  color: #fff;
}
</style>