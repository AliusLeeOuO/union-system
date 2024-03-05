<template>
  <div>
    <h1>用户管理</h1>
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
    <template #action="{ record }">
      <a-space class="active-buttons">
        <a-button type="primary">修改 {{ record.id }}</a-button>
      </a-space>
    </template>
  </a-table>
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


const adminApi = useAdminApi()
const searchFormRef = ref<FormInstance | null>(null)
const searchFormItem = reactive({
  id: "",
  username: "",
  role: -1
})

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
  const { data } = await handleXhrResponse(() => adminApi.getUserList(pageItem.current, pageItem.pageSize, processedValue(), searchFormItem.username, searchFormItem.role), Message)
  dataSource.splice(0, dataSource.length)
  pageItem.total = data.data.total
  pageItem.pageSize = data.data.page_size

  if (data.data.data === null) {
    return
  }

  for (let i = 0; i < data.data.data.length; i++) {
    dataSource.push({
      id: data.data.data[i].id,
      username: data.data.data[i].username,
      role: data.data.data[i].role,
      status: data.data.data[i].status
    })
  }

}

onMounted(async () => {
  await fetchUserList()
})


</script>
<style scoped lang="less">
.panel {
  background-color: #232324;

  .banner {
    width: 100%;
    padding: 20px 20px 0;
    background-color: var(--color-bg-2);
    border-radius: 4px 4px 0 0;
    font-size: 20px;
    line-height: 1.4;
  }

  .card-item {
    padding: 20px;

    .active-buttons {
      & > * {
        margin-right: 10px;
      }
    }
  }
}
</style>