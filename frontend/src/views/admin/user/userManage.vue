<template>
  <div class="prime-actions">
    <a-space>
      <router-link to="/admin/addNewUser" custom v-slot="{ navigate }">
        <a-button status="success" @click="navigate">添加新用户</a-button>
      </router-link>
    </a-space>
    <a-space>
      <a-button @click="submitSearch">
        <template #icon>
          <icon-refresh />
        </template>
        刷新
      </a-button>
    </a-space>
  </div>
  <div class="search-item">
    <a-form
      layout="inline"
      ref="searchFormRef"
      :model="searchFormItem"
      @submit="submitSearch"
    >
      <a-form-item field="id" label="ID">
        <a-input v-model="searchFormItem.id" placeholder="以ID查询" />
      </a-form-item>
      <a-form-item field="username" label="用户名">
        <a-input v-model="searchFormItem.username" placeholder="以用户名查询" />
      </a-form-item>
      <a-form-item field="role" label="角色">
        <a-select :style="{width:'200px'}" placeholder="选择角色" v-model="searchFormItem.role">
          <a-option :value="-1">所有角色</a-option>
          <a-option :value="roles.ADMIN">管理员</a-option>
          <a-option :value="roles.USER">用户</a-option>
        </a-select>
      </a-form-item>
      <a-form-item>
        <a-space>
          <a-button html-type="submit" type="primary">查询</a-button>
          <a-button status="danger" @click="resetFormItem">清空查询条件</a-button>
        </a-space>
      </a-form-item>
    </a-form>
  </div>
  <a-table
    :columns="columns"
    :data="dataSource"
    @page-change="changePage"
    :loading="tableLoading"
    :pagination="{
      total: pageItem.total,
      pageSize: pageItem.pageSize,
      current: pageItem.current
    }"
  >
    <template #role="{ record }">
      <a-tag>{{ getRoleName(record.role) }}</a-tag>
    </template>
    <template #status="{ record }">
      <a-tag color="cyan" v-if="record.status">正常</a-tag>
      <a-tag color="gray" v-else>冻结</a-tag>
    </template>
    <template #create_time="{ record }">
      <span>{{ dayjs.tz(record.create_time).format("YYYY-MM-DD") }}</span>
    </template>
    <template #action="{ record }">
      <a-space class="active-buttons">
        <router-link :to="`/admin/manageSoloUser/${record.id}`" custom v-slot="{ navigate }">
          <a-button type="primary" @click="navigate">修改</a-button>
        </router-link>
      </a-space>
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { roles } from "@/router"
import { getRoleName } from "@/utils/roleHelper"
import dayjs from "dayjs"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"
import useAdminApi, { type userListItem } from "@/api/adminApi"
import { onMounted, reactive, ref } from "vue"
import { type FormInstance, Message } from "@arco-design/web-vue"
import type { TableColumnData } from "@arco-design/web-vue/es/table/interface"
import { handleXhrResponse } from "@/api"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const adminApi = useAdminApi()
const searchFormRef = ref<FormInstance | null>(null)
const searchFormItem = reactive({
  id: "",
  username: "",
  role: -1
})
const tableLoading = ref(true)

const columns: TableColumnData[] = [
  {
    title: "用户ID",
    dataIndex: "id"
  },
  {
    title: "用户名",
    dataIndex: "username"
  },
  {
    title: "角色",
    slotName: "role"
  },
  {
    title: "账号创建时间",
    slotName: "create_time"
  },
  {
    title: "账号状态",
    slotName: "status"
  },
  {
    title: "操作",
    slotName: "action"
  }
]
const dataSource = reactive<userListItem[]>([])

const processedValue = (): number => {
  if (searchFormItem.id === "") {
    return -1
  }
  return parseInt(searchFormItem.id)
}

const pageItem = reactive({
  pageSize: 10,
  current: 1,
  total: 0
})

const changePage = async (page: number) => {
  pageItem.current = page
  await fetchUserList()
}

const submitSearch = async () => {
  pageItem.current = 1
  await fetchUserList()
}

const resetFormItem = async () => {
  searchFormRef.value?.resetFields()
  await submitSearch()
}

const fetchUserList = async () => {
  tableLoading.value = true
  const { data } = await handleXhrResponse(() => adminApi.getUserList(pageItem.current, pageItem.pageSize, processedValue(), searchFormItem.username, searchFormItem.role), Message)
  dataSource.splice(0, dataSource.length)
  pageItem.total = data.data.total
  pageItem.pageSize = data.data.page_size

  if (data.data.data !== null) {
    dataSource.push(...data.data.data)
  }
  tableLoading.value = false
}

onMounted(async () => {
  await fetchUserList()
})
</script>
<style scoped lang="less">
.prime-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}
</style>