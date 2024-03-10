<template>
  <a-typography-title :heading="2">
    用户管理
  </a-typography-title>
  <a-space>
    <router-link to="/admin/user/manage" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">用户管理</a-button>
    </router-link>
    <router-link to="/admin/user/invitationCode" custom v-slot="{ navigate, isActive }">
      <a-button @click="navigate" :type="isActive? 'primary': 'text'">邀请码管理</a-button>
    </router-link>
  </a-space>
  <div class="router-container">
    <router-view />
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted, reactive } from "vue"
import { roles } from "@/router"
import { getRoleName } from "@/utils/roleHelper"
import { handleXhrResponse } from "@/api"
import useAdminApi, { type userListItem } from "@/api/adminApi"
import { Message } from "@arco-design/web-vue"
import type { FormInstance } from "@arco-design/web-vue"
import type { TableColumnData } from "@arco-design/web-vue/es/table/interface"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"








</script>
<style scoped lang="less">
.router-container {
  margin: 20px 0;
}

</style>