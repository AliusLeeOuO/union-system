<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{ route }">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <a-typography-title :heading="2">
    援助管理
  </a-typography-title>
  <div class="mb-3 flex justify-between">
    <a-form ref="searchFormRef" :model="searchForm" layout="inline" @submit="submitSearch">
      <a-form-item label="ID">
        <a-input v-model="searchForm.id" placeholder="通过ID查找" />
      </a-form-item>
      <a-form-item label="类型">
        <a-select v-model="searchForm.type" :style="{ width: '180px' }">
          <a-option value="">
            所有类型
          </a-option>
          <a-option value="1">
            法律援助
          </a-option>
          <a-option value="2">
            紧急援助
          </a-option>
          <a-option value="3">
            职业发展援助
          </a-option>
        </a-select>
      </a-form-item>
      <div>
        <a-space>
          <a-button type="primary" html-type="submit">
            查询
          </a-button>
          <a-button status="danger" @click="resetSearch">
            清空查询条件
          </a-button>
        </a-space>
      </div>
    </a-form>
    <a-button @click="refreshList">
      <template #icon>
        <IconRefresh />
      </template>
      刷新
    </a-button>
  </div>
  <a-table
    :columns="columns"
    :data="tableData"
    size="large"
    :loading="tableLoading"
    :pagination="{
      total: pageData.total,
      pageSize: pageData.pageSize,
      current: pageData.currentPage,
    }"
    @page-change="changePage"
  >
    <template #status="{ record }">
      <a-tag v-if="record.status === 1" color="cyan">
        待审核
      </a-tag>
      <a-tag v-else-if="record.status === 2" color="blue">
        处理中
      </a-tag>
      <a-tag v-else-if="record.status === 3" color="green">
        已解决
      </a-tag>
      <a-tag v-else-if="record.status === 4" color="gray">
        已关闭
      </a-tag>
    </template>
    <template #create_time="{ record }">
      {{ dayjs.tz(record.create_time).format('YYYY-MM-DD HH:mm:ss') }}
    </template>
    <template #type="{ record }">
      {{ record.assistance_type.name }}
    </template>
    <template #action="{ record }">
      <router-link v-slot="{ navigate }" :to="`/admin/manageAssistanceDetail/${record.id}`" custom>
        <a-button type="primary" @click="navigate">
          操作
        </a-button>
      </router-link>
    </template>
  </a-table>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import dayjs from 'dayjs'
import { type BreadcrumbRoute, type FormInstance, Message } from '@arco-design/web-vue'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type assistanceListItem } from '@/api/adminApi'

const adminApi = useAdminApi()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: '/admin/manageAssistance',
    label: '援助管理'
  }
]

const searchFormRef = ref<FormInstance | null>(null)
const tableLoading = ref(true)

const columns = [
  {
    title: '援助ID',
    dataIndex: 'id'
  },
  {
    title: '援助用户',
    dataIndex: 'username'
  },
  {
    title: '援助标题',
    dataIndex: 'title'
  },
  {
    title: '援助类型',
    slotName: 'type'
  },
  {
    title: '发起时间',
    slotName: 'create_time'
  },
  {
    title: '援助状态',
    slotName: 'status'
  },
  {
    title: '操作',
    slotName: 'action'
  }
]

const tableData = reactive<assistanceListItem[]>([])

const searchForm = reactive({
  id: '',
  type: ''
})

const pageData = reactive({
  total: 0,
  pageSize: 10,
  currentPage: 1
})

async function changePage(page: number) {
  pageData.currentPage = page
  await fetchAssistanceList()
}

async function submitSearch() {
  pageData.currentPage = 1
  await fetchAssistanceList()
}

function resetSearch() {
  searchForm.id = ''
  searchForm.type = ''
  pageData.currentPage = 1
  fetchAssistanceList()
}

async function refreshList() {
  pageData.currentPage = 1
  await submitSearch()
}

async function fetchAssistanceList() {
  tableLoading.value = true
  // 构建基本的参数对象
  const params: {
    pageNum: number
    pageSize: number
    assistance_type_id?: number
    id?: number
  } = {
    pageNum: pageData.currentPage,
    pageSize: pageData.pageSize
  }

  // 如果 id 不为空且可以转换为数字，则添加到参数对象中
  if (searchForm.id) {
    const idNumber = Number(searchForm.id)
    if (!Number.isNaN(idNumber)) { // 确保转换后是有效数字
      params.id = idNumber
    }
  }

  // 如果 type 不为空且可以转换为数字，则添加到参数对象中
  if (searchForm.type) {
    const typeIdNumber = Number(searchForm.type)
    if (!Number.isNaN(typeIdNumber)) { // 确保转换后是有效数字
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
