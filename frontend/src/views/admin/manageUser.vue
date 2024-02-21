<template>
  <div class="panel">
    <a-space direction="vertical" :size="16" style="display: block;">
      <a-row>
        <a-col :span="24">
          <div class="banner">用户管理</div>
        </a-col>
      </a-row>
      <a-divider />
      <a-row class="card-item">
        <div class="search-item">
          <a-form layout="inline" :model="searchFormItem">
            <a-form-item field="id" label="ID">
              <a-input v-model="searchFormItem.id" placeholder="以ID查询" />
            </a-form-item>
            <a-form-item field="username" label="用户名">
              <a-input v-model="searchFormItem.username" placeholder="以用户名查询" />
            </a-form-item>
            <a-form-item field="role" label="角色">
              <a-select :style="{width:'200px'}" placeholder="选择角色" v-model="searchFormItem.role">
                <a-option :value="roles.ADMIN">管理员</a-option>
                <a-option :value="roles.USER">用户</a-option>
              </a-select>
            </a-form-item>
            <a-form-item>
              <div class="active-buttons">
                <a-button html-type="submit" type="primary">查询</a-button>
                <a-button html-type="reset" status="danger">清空</a-button>
              </div>
            </a-form-item>
          </a-form>
        </div>
      </a-row>
      <a-row class="card-item">
        <a-col :span="24">
          <a-table :columns="columns" :data="dataSource" />
        </a-col>
      </a-row>
    </a-space>
  </div>
</template>
<script setup lang="ts">
import { onMounted, reactive } from "vue"
import { roles } from "@/router"
import { handleXhrResponse } from "@/api"
import useAdminApi, { type getUserResponseData } from "@/api/adminApi"
import { Message } from "@arco-design/web-vue"
import type { TableColumnData } from "@arco-design/web-vue/es/table/interface"


const adminApi = useAdminApi()
const searchFormItem = reactive({
  id: "",
  username: "",
  role: ""
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
    dataIndex: "role"
  },
  {
    title: "账号状态",
    dataIndex: "status"
  },
  {
    title: "操作",
    slotName: "action"
  }
]
const dataSource = reactive<getUserResponseData["data"]>([])

onMounted(async () => {
  try {
    const { data } = await handleXhrResponse(() => adminApi.getUserList(1, 10), Message)
    for (let i = 0; i < data.data.data.length; i++) {
      dataSource.push({
        id: data.data.data[i].id,
        username: data.data.data[i].username,
        role: data.data.data[i].role,
        status: data.data.data[i].status
      })
    }
  } catch (e) {
    console.error(e)
  }
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