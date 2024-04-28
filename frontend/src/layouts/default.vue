<template>
  <v-head />
  <main class="pl-4 pr-4">
    <RouterView />
  </main>
  <v-foot />
</template>
<script setup lang="ts">
  import VHead from "@/components/vHead.vue"
  import VFoot from "@/components/vFoot.vue"
</script>
<style scoped lang="less">
main {
  min-height: 70vh;
  max-width: 1400px;
  margin: 20px auto;
}
</style>
