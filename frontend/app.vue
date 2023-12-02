<template>
  <div class="safe-area" :style="safeAreaStyle">
    <nuxt-layout>
      <nuxt-page />
    </nuxt-layout>
  </div>
</template>
<script lang="ts" setup>
import { useScreenSafeArea } from "@vueuse/core"

const {
  top,
  right,
  bottom,
  left
} = useScreenSafeArea()

// 添加边距到safe-area
const safeAreaStyle = {
  paddingTop: `${top.value}px`,
  paddingRight: `${right.value}px`,
  paddingBottom: `${bottom.value}px`,
  paddingLeft: `${left.value}px`
}
</script>