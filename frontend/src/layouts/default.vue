<template>
  <v-head />
  <main>
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
  max-width: 1400px;
  margin: 20px auto;
  padding: 0 20px;
}
</style>