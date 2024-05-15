<template>
  <router-link
    :to="to"
    custom
    v-slot="{ navigate, isActive }"
    v-if="hasPermission"
  >
    <a-button @click="navigate" :type="isActive ? 'primary' : 'text'">
      <slot></slot>
    </a-button>
  </router-link>
</template>

<script setup lang="ts">
import { computed } from "vue"
import { useUserStore } from "@/stores/user"
import { findPermissionNode } from "@/utils/roleHelper"

const props = defineProps<{
  to: string
}>()

const userStore = useUserStore()

const hasPermission = computed(() => findPermissionNode(userStore.userPermissions, props.to))
</script>
