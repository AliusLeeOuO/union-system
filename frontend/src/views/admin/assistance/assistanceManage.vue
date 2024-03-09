<template>
  <a-typography-title :heading="2">
    援助管理
  </a-typography-title>
  <div class="action-zone">
    <a-form ref="searchFormRef" :model="searchForm" layout="inline" @submit="submitSearch">
      <a-form-item label="ID">
        <a-input v-model="searchForm.id" placeholder="通过ID查找" />
      </a-form-item>
      <a-form-item label="类型">
        <a-select :style="{width:'180px'}" v-model="searchForm.type">
          <a-option value="">所有类型</a-option>
          <a-option value="1">法律援助</a-option>
          <a-option value="2">紧急援助</a-option>
          <a-option value="3">职业发展援助</a-option>
        </a-select>
      </a-form-item>
      <div>
        <a-space>
          <a-button type="primary" html-type="submit">查询</a-button>
          <a-button status="danger" @click="resetSearch">清空查询条件</a-button>
        </a-space>
      </div>
    </a-form>
    <a-button @click="refreshList">
      <template #icon>
        <icon-refresh />
      </template>
      刷新
    </a-button>
  </div>
  <a-table
    :columns="columns"
    :data="tableData"
    size="large"
    @page-change="changePage"
    :loading="tableLoading"
    :pagination="{
      total: pageData.total,
      pageSize: pageData.pageSize,
      current: pageData.currentPage
    }"
  >
    <template #status="{ record }">
      <a-tag color="cyan" v-if="record.status === 1">待审核</a-tag>
      <a-tag color="blue" v-else-if="record.status === 2">处理中</a-tag>
      <a-tag color="green" v-else-if="record.status === 3">已解决</a-tag>
      <a-tag color="gray" v-else-if="record.status === 4">已关闭</a-tag>
    </template>
    <template #create_time="{ record }">
      {{ dayjs.tz(record.create_time).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
    <template #type="{ record }">
      {{ record.assistance_type.name }}
    </template>
    <template #action="{ record }">
      <router-link :to="`/admin/manageAssistanceDetail/${record.id}`" custom v-slot="{ navigate }">
        <a-button type="primary" @click="navigate">操作</a-button>
      </router-link>
    </template>
  </a-table>
</template>
<script setup lang="ts">
import { onMounted, reactive, ref } from "vue"
import { IconRefresh } from "@arco-design/web-vue/es/icon"
import dayjs from "dayjs"
import useAdminApi, { type assistanceListItem } from "@/api/adminApi"
import { type FormInstance, Message } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

const adminApi = useAdminApi()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const searchFormRef = ref<FormInstance | null>(null)
const tableLoading = ref(true)


const columns = [
  {
    title: "援助ID",
    dataIndex: "id"
  },
  {
    title: "援助用户",
    dataIndex: "username"
  },
  {
    title: "援助标题",
    dataIndex: "title"
  },
  {
    title: "援助类型",
    slotName: "type"
  },
  {
    title: "发起时间",
    slotName: "create_time"
  },
  {
    title: "援助状态",
    slotName: "status"
  },
  {
    title: "操作",
    slotName: "action"
  }
]

const tableData = reactive<assistanceListItem[]>([])

const searchForm = reactive({
  id: "",
  type: ""
})

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

const changePage = async (page: number) => {
  pageData.currentPage = page
  await fetchAssistanceList()
}

const submitSearch = async () => {
  pageData.currentPage = 1
  await fetchAssistanceList()
}

const resetSearch = () => {
  searchForm.id = ""
  searchForm.type = ""
  pageData.currentPage = 1
  fetchAssistanceList()
}

const refreshList = async () => {
  pageData.currentPage = 1
  await submitSearch()
}

const fetchAssistanceList = async () => {
  tableLoading.value = true
  // 构建基本的参数对象
  let params: {
    pageNum: number;
    pageSize: number;
    assistance_type_id?: number;
    id?: number;
  } = {
    pageNum: pageData.currentPage,
    pageSize: pageData.pageSize
  }

  // 如果 id 不为空且可以转换为数字，则添加到参数对象中
  if (searchForm.id) {
    const idNumber = Number(searchForm.id)
    if (!isNaN(idNumber)) { // 确保转换后是有效数字
      params.id = idNumber
    }
  }

  // 如果 type 不为空且可以转换为数字，则添加到参数对象中
  if (searchForm.type) {
    const typeIdNumber = Number(searchForm.type)
    if (!isNaN(typeIdNumber)) { // 确保转换后是有效数字
      params.assistance_type_id = typeIdNumber
    }
  }

  // 调用 API，并传递构建好的参数对象
  const { data } = await handleXhrResponse(() => adminApi.getAssistanceList(params.pageNum, params.pageSize, params.assistance_type_id, params.id), Message)

  // 更新表格数据和分页数据
  tableData.splice(0, tableData.length)
  pageData.total = data.data.total
  if (data.data.data) {
    tableData.push(...data.data.data)
  }
  tableLoading.value = false
}


onMounted(async () => {
  await fetchAssistanceList()
})

</script>
<style scoped lang="less">
.action-zone {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}
</style>