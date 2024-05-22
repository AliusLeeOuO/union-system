<template>
  <a-card class="mb-4">
    <div class="flex justify-between">
      <a-space>
        <a-button @click="addNewType">
          添加类型
        </a-button>
      </a-space>
    </div>
  </a-card>
  <a-card class="mb-4">
    <div class="flex justify-between">
      <a-space />
      <a-space>
        <a-button @click="fetchTypes">
          <template #icon>
            <IconRefresh />
          </template>
          刷新
        </a-button>
      </a-space>
    </div>
  </a-card>
  <a-card>
    <a-table :columns="columns" :data="tableData" :pagination="false" :loading="fetchTypeDataLoading">
      <template #action="{ record }">
        <a-popconfirm content="确定要删除吗？" type="warning" :on-before-ok="handlerDeleteType(record.assistance_type_id)">
          <a-button type="primary" status="danger">
            删除
          </a-button>
        </a-popconfirm>
      </template>
    </a-table>
  </a-card>
  <a-modal
    v-model:visible="addNewTypeVisible"
    title="添加新类型"
    :ok-loading="newTypeAddLoading"
    @cancel="addNewTypeVisible = false"
    @before-ok="addNewTypeFormHandleBeforeOk"
  >
    <a-form :model="newAssistanceTypeForm" :rules="newAssistanceTypeFormRules">
      <a-form-item field="standardName" label="类型名称">
        <a-input v-model="newAssistanceTypeForm.standardName" :disabled="newTypeAddLoading" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import type { TableColumnData } from '@arco-design/web-vue/es/table/interface'
import { type FieldRule, Message } from '@arco-design/web-vue'
import useAdminApi, { type assistanceTypeResponse } from '@/api/adminApi'
import { handleXhrResponse } from '@/api'

const { getAssistanceTypes, newAssistanceType, deleteAssistanceType } = useAdminApi()

const columns: TableColumnData[] = [
  {
    title: '类型名称',
    dataIndex: 'type_name'
  },
  {
    title: '操作',
    slotName: 'action',
    width: 200
  }
]

const tableData = reactive<assistanceTypeResponse[]>([])
const fetchTypeDataLoading = ref(false)

async function fetchTypes() {
  try {
    fetchTypeDataLoading.value = true
    const { data } = await handleXhrResponse(() => getAssistanceTypes(), Message)
    tableData.splice(0, tableData.length, ...data.data)
    fetchTypeDataLoading.value = false
  }
  catch (e) {
    fetchTypeDataLoading.value = false
    Message.error('获取类型数据失败')
    console.error(e)
  }
}

onMounted(async () => {
  await fetchTypes()
})

// 添加新类型
const addNewTypeVisible = ref(false)
const newTypeAddLoading = ref(false)

function addNewType() {
  addNewTypeVisible.value = true
}

const newAssistanceTypeForm = reactive({
  standardName: ''
})

async function addNewTypeFormHandleBeforeOk(done: (closed: boolean) => void) {
  try {
    newTypeAddLoading.value = true
    await handleXhrResponse(() => newAssistanceType(newAssistanceTypeForm.standardName), Message)
    Message.success('添加成功')
    done(true)
    await fetchTypes()
  }
  catch (e) {
    console.error(e)
    done(false)
  }
  finally {
    newTypeAddLoading.value = false
  }
}

const newAssistanceTypeFormRules: Record<string, FieldRule | FieldRule[]> = {
  standardName: [
    { required: true, message: '请输入类型名称' }
  ]
}

// 删除类型
async function fetchDeleteType(id: number) {
  try {
    await handleXhrResponse(() => deleteAssistanceType(id), Message)
    Message.success('删除成功')
    await fetchTypes()
  }
  catch (e) {
    console.error(e)
  }
}

function handlerDeleteType(id: number) {
  return function (done: (closed: boolean) => void): void | boolean | Promise<void | boolean> {
    return new Promise((resolve) => {
      fetchDeleteType(id).then(() => {
        done(true)
        resolve()
      }).catch(() => {
        done(false)
        resolve()
      })
    })
  }
}
</script>

<style scoped lang="less">

</style>
