<template>
  <a-card>
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
      <template #register_at="{ record }">
        {{ dayjs.tz(record.register_at).format('YYYY-MM-DD HH:mm:ss') }}
      </template>
      <template #action="{ record }">
        <a-button @click="openChangeFeeStandardModal(record.user_id, -1, record.username)">
          注册会员费率
        </a-button>
      </template>
    </a-table>
  </a-card>
  <a-modal
    v-model:visible="changeFeeStandardVisible" title="注册费率标准" @cancel="changeFeeStandardVisible = false"
    @before-ok="newFeeStandardFormHandleBeforeOk"
  >
    <a-form :model="newFeeStandardForm">
      <a-form-item field="name" label="用户名">
        <a-input v-model="newFeeStandardForm.username" disabled />
      </a-form-item>
      <a-form-item field="standardId" label="费率标准">
        <a-select v-model="newFeeStandardForm.standardId" placeholder="选择费率标准">
          <a-option :value="-1" disabled>
            选择费率
          </a-option>
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
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type feeListItem, type nonRegisteredFeeListItem } from '@/api/adminApi'

const { getNonRegisteredFeeList, changeMemberFeeStandard, getFeeStandardList } = useAdminApi()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

const columns = [
  {
    title: '用户名',
    slotName: 'username'
  },
  {
    title: '注册时间',
    slotName: 'register_at'
  },
  {
    title: '操作',
    slotName: 'action',
    width: 200
  }
]

const registeredFeeList = reactive<nonRegisteredFeeListItem[]>([])

const page = reactive({
  current: 1,
  pageSize: 10,
  total: 0
})

async function fetchNonRegFeeList() {
  const { data } = await handleXhrResponse(() => getNonRegisteredFeeList(page.current, page.pageSize), Message)
  page.total = data.data.total
  if (data.data.users !== null) {
    registeredFeeList.splice(0, registeredFeeList.length, ...data.data.users)
  }
}

async function changePage(newPage: number) {
  page.current = newPage
  await fetchNonRegFeeList()
}

onMounted(() => {
  fetchNonRegFeeList()
})

// 注册会员费率
const changeFeeStandardVisible = ref(false)
const newFeeStandardForm = reactive({
  standardId: -1,
  username: '',
  id: -1
})

async function newFeeStandardFormHandleBeforeOk(done: (closed: boolean) => void) {
  if (newFeeStandardForm.standardId === -1) {
    Message.error('请选择费率标准')
    done(false)
    return
  }

  await handleXhrResponse(() => changeMemberFeeStandard(newFeeStandardForm.id, newFeeStandardForm.standardId), Message)
  done(true)
  Message.success('注册会员费率成功')
  changeFeeStandardVisible.value = false
  // 恢复默认值
  newFeeStandardForm.standardId = -1
  newFeeStandardForm.username = ''
  newFeeStandardForm.id = -1
  await fetchNonRegFeeList()
}

async function openChangeFeeStandardModal(id: number, currentStandardId: number, username: string) {
  newFeeStandardForm.id = id
  newFeeStandardForm.standardId = currentStandardId
  newFeeStandardForm.username = username
  changeFeeStandardVisible.value = true
}

// 获取费率标准
const feeList = reactive<feeListItem[]>([])

async function fetchFeeList() {
  const { data } = await handleXhrResponse(() => getFeeStandardList(), Message)
  feeList.splice(0, feeList.length, ...data.data)
}

onMounted(() => {
  fetchFeeList()
})
</script>

<style scoped lang="less">

</style>
