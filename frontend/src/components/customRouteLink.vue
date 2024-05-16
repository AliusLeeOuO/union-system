<template>
  <router-link
    v-if="hasPermission"
    v-slot="{ navigate, isActive }"
    :to="to"
    custom
  >
    <a-button :type="isActive ? 'primary' : 'text'" @click="navigate">
      <slot />
    </a-button>
  </router-link>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { findPermissionNode } from '@/utils/roleHelper'

const props = defineProps<{
  to: string
}>()

const userStore = useUserStore()

const hasPermission = computed(() => findPermissionNode(userStore.userPermissions, props.to))
</script>
