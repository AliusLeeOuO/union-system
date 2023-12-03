<template>
  <v-head></v-head>
  <slot></slot>
  <client-only>
    <v-foot></v-foot>
  </client-only>
</template>
<script setup lang="ts">
import VHead from "~/components/vHead.vue"
import VFoot from "~/components/vFoot.vue"
</script>
<style scoped lang="less">

</style>