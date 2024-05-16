<template>
  <a-table
    :columns="columns"
    :data="registeredFeeList"
    size="large"
    :pagination="{
      total: page.total,
      pageSize: page.pageSize,
      current: page.current,
    }"
    @page-change="changePage"
  >
    <template #username="{ record }">
      <a-popover>
        <div>
          {{ record.username }}
        </div>
        <template #content>
          <p>用户ID：{{ record.user_id }}</p>
        </template>
      </a-popover>
    </template>
    <template #regTime="{ record }">
      {{ dayjs.tz(record.registration_date).format('YYYY-MM-DD HH:mm:ss') }}
    </template>
    <template #action="{ record }">
      <a-space>
        <a-button
          type="primary"
          @click="openChangeFeeStandardModal(record.user_id, record.fee_standard_id, record.username)"
        >
          修改费率标准
        </a-button>
        <a-popconfirm content="确定要取消会费规则吗？" type="warning" @ok="handlerRemoveFeeStandard(record.user_id)">
          <a-button type="primary" status="danger">
            取消会费规则
          </a-button>
        </a-popconfirm>
      </a-space>
    </template>
  </a-table>
  <a-modal
    v-model:visible="changeFeeStandardVisible" title="修改费率标准" @cancel="changeFeeStandardVisible = false"
    @before-ok="newFeeStandardFormHandleBeforeOk"
  >
    <a-form :model="newFeeStandardForm">
      <a-form-item field="name" label="用户名">
        <a-input v-model="newFeeStandardForm.username" disabled />
      </a-form-item>
      <a-form-item field="standardId" label="费率标准">
        <a-select v-model="newFeeStandardForm.standardId" placeholder="选择费率标准">
          <a-option v-for="item in feeList" :key="item.standard_id" :value="item.standard_id">
            {{ item.standard_name }} |
            {{ item.amount }}
          </a-option>
        </a-select>
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { onMounted, reactive, ref } from 'vue'
import { Message } from '@arco-design/web-vue'
import useAdminApi, { type feeListItem, type registeredFeeListItem } from '@/api/adminApi'
import { handleXhrResponse } from '@/api'

const { getRegisteredFeeList, getFeeStandardList, changeMemberFeeStandard, removeMemberFeeStandard } = useAdminApi()
const columns = [
  {
    title: '用户名',
    slotName: 'username'
  },
  {
    title: '会费标准',
    dataIndex: 'fee_standard_name'
  },
  {
    title: '会费金额',
    dataIndex: 'fee_amount'
  },
  {
    title: '会员注册时间',
    slotName: 'regTime'
  },
  {
    title: '操作',
    slotName: 'action',
    width: 400
  }
]

const registeredFeeList = reactive<registeredFeeListItem[]>([])

const page = reactive({
  current: 1,
  pageSize: 10,
  total: 0
})

async function fetchFeeMemberList() {
  const { data } = await handleXhrResponse(() => getRegisteredFeeList(page.current, page.pageSize), Message)
  page.total = data.data.total
  if (data.data.users !== null) {
    registeredFeeList.splice(0, registeredFeeList.length, ...data.data.users)
  }
}

async function changePage(newPage: number) {
  page.current = newPage
  await fetchFeeMemberList()
}

onMounted(async () => {
  await fetchFeeMemberList()
  await fetchFeeList()
})

// 获取费率标准
const feeList = reactive<feeListItem[]>([])

async function fetchFeeList() {
  const { data } = await handleXhrResponse(() => getFeeStandardList(), Message)
  feeList.splice(0, feeList.length, ...data.data)
}

const changeFeeStandardVisible = ref(false)

const newFeeStandardForm = reactive({
  standardId: -1,
  username: '',
  id: -1
})

async function newFeeStandardFormHandleBeforeOk(done: (closed: boolean) => void) {
  await handleXhrResponse(() => changeMemberFeeStandard(newFeeStandardForm.id, newFeeStandardForm.standardId), Message)
  done(true)
  Message.success('修改成功')
  changeFeeStandardVisible.value = false
  await fetchFeeMemberList()
}

async function openChangeFeeStandardModal(id: number, currentStandardId: number, username: string) {
  newFeeStandardForm.id = id
  newFeeStandardForm.standardId = currentStandardId
  newFeeStandardForm.username = username
  changeFeeStandardVisible.value = true
}

// 取消会费规则
async function handlerRemoveFeeStandard(id: number) {
  await handleXhrResponse(() => removeMemberFeeStandard(id), Message)
  Message.success('取消成功')
  await fetchFeeMemberList()
}
</script>

<style scoped lang="less">

</style>
