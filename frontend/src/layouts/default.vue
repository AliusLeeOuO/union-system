<template>
  <VHead />
  <div class="main flex gap-2">
    <a-menu
      class="h-full max-w-60" :default-open-keys="['0']" :default-selected-keys="['0_2']" show-collapse-button
      breakpoint="xl"
    >
      <a-sub-menu key="0">
        <template #icon>
          <icon-apps />
        </template>
        <template #title>
          Navigation 1
        </template>
        <a-menu-item key="0_0">
          Menu 1
        </a-menu-item>
        <a-menu-item key="0_1">
          Menu 2
        </a-menu-item>
        <a-menu-item key="0_2">
          Menu 3
        </a-menu-item>
        <a-menu-item key="0_3">
          Menu 4
        </a-menu-item>
      </a-sub-menu>
      <a-sub-menu key="1">
        <template #icon>
          <icon-bug />
        </template>
        <template #title>
          Navigation 2
        </template>
        <a-menu-item key="1_0">
          Menu 1
        </a-menu-item>
        <a-menu-item key="1_1">
          Menu 2
        </a-menu-item>
        <a-menu-item key="1_2">
          Menu 3
        </a-menu-item>
      </a-sub-menu>
      <a-sub-menu key="2">
        <template #icon>
          <icon-bulb />
        </template>
        <template #title>
          Navigation 3
        </template>
        <a-menu-item key="2_0">
          Menu 1
        </a-menu-item>
        <a-menu-item key="2_1">
          Menu 2
        </a-menu-item>
        <a-sub-menu key="2_2" title="Navigation 4">
          <a-menu-item key="2_2_0">
            Menu 1
          </a-menu-item>
          <a-menu-item key="2_2_1">
            Menu 2
          </a-menu-item>
        </a-sub-menu>
      </a-sub-menu>
    </a-menu>
    <div class="mr-2 flex-1">
      <RouterView />
    </div>
  </div>
  <main class="pl-4 pr-4" />
  <VFoot />
</template>

<script setup lang="ts">
import VHead from '@/components/vHead.vue'
import VFoot from '@/components/vFoot.vue'
</script>

<style scoped lang="less">
@import "../assets/variable.less";

.main {
  height: calc(100vh - @header-height);
  main {
    max-width: 1400px;
    margin: 20px auto;
  }
}
</style>
