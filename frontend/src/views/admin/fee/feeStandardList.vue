<template>
  <a-card class="mb-4">
    <div class="flex justify-between flex-items-center">
      <a-space>
        <a-button status="success" @click="newFeeStandardVisible = true">
          添加新费率
        </a-button>
      </a-space>
      <a-space>
        <a-button @click="fetchFeeList(true)">
          <template #icon>
            <IconRefresh />
          </template>
          刷新
        </a-button>
      </a-space>
    </div>
  </a-card>
  <a-card>
    <a-table
      :columns="columns"
      :data="feeList"
      size="large"
      :pagination="false"
    >
      <template #standard_name="{ record }">
        <a-popover>
          <div>
            {{ record.standard_name }}
          </div>
          <template #content>
            <p>费率ID：{{ record.standard_id }}</p>
          </template>
        </a-popover>
      </template>
      <template #regTime="{ record }">
        {{ dayjs.tz(record.registration_date).format('YYYY-MM-DD HH:mm:ss') }}
      </template>
      <template #action="{ record }">
        <a-button @click="handlerVisible(record.standard_id)">
          修改费率标准
        </a-button>
      </template>
    </a-table>
  </a-card>
  <a-modal
    v-model:visible="changeFeeStandardVisible" title="修改费率标准" @cancel="changeFeeStandardVisible = false"
    @before-ok="changeFeeStandardFormHandleBeforeOk"
  >
    <a-form :model="changeFeeStandardForm">
      <a-form-item field="name" label="费率ID">
        <a-input-number v-model="changeFeeStandardForm.id" disabled />
      </a-form-item>
      <a-form-item field="name" label="费率名称">
        <a-input v-model="changeFeeStandardForm.name" />
      </a-form-item>
      <a-form-item field="post" label="费率金额">
        <a-input-number v-model="changeFeeStandardForm.amount" :precision="2" />
      </a-form-item>
    </a-form>
  </a-modal>
  <a-modal
    v-model:visible="newFeeStandardVisible" title="修改费率标准" @cancel="newFeeStandardVisible = false"
    @before-ok="newFeeStandardFormHandleBeforeOk"
  >
    <a-form :model="newFeeStandardForm">
      <a-form-item field="name" label="费率名称">
        <a-input v-model="newFeeStandardForm.name" />
      </a-form-item>
      <a-form-item field="post" label="费率金额">
        <a-input-number v-model="newFeeStandardForm.amount" :precision="2" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { onMounted, reactive, ref } from 'vue'
import { Message } from '@arco-design/web-vue'
import { IconRefresh } from '@arco-design/web-vue/es/icon'
import useAdminApi, { type feeListItem } from '@/api/adminApi'
import { handleXhrResponse } from '@/api'

const { getFeeStandardList, modifyFeeStandard, addFeeStandard } = useAdminApi()
const columns = [
  {
    title: '费率标准',
    slotName: 'standard_name'
  },
  {
    title: '费率金额',
    dataIndex: 'amount'
  },
  {
    title: '操作',
    slotName: 'action',
    width: 200
  }
]

const feeList = reactive<feeListItem[]>([])

async function fetchFeeList(notice = false) {
  const { data } = await handleXhrResponse(() => getFeeStandardList(), Message)
  feeList.splice(0, feeList.length, ...data.data)
  if (notice) {
    Message.success('获取费率列表成功')
  }
}

onMounted(() => {
  fetchFeeList()
})

// 修改费率标准

const changeFeeStandardVisible = ref(false)

const changeFeeStandardForm = reactive({
  name: '',
  amount: 0.00,
  id: -1
})

async function changeFeeStandardFormHandleBeforeOk(done: (closed: boolean) => void) {
  await fetchChangeFee()
  done(true)
  Message.success('修改成功')
  changeFeeStandardForm.id = -1
  changeFeeStandardForm.name = ''
  changeFeeStandardForm.amount = 0.00
  await fetchFeeList()
}

async function fetchChangeFee() {
  await handleXhrResponse(() => modifyFeeStandard(changeFeeStandardForm.id, changeFeeStandardForm.amount, changeFeeStandardForm.name), Message)
}

function handlerVisible(standardId: number) {
  changeFeeStandardForm.id = standardId
  // 从feeList中找到对应的费率标准
  const standard = feeList.find(item => item.standard_id === standardId)
  if (standard) {
    changeFeeStandardForm.name = standard.standard_name
    changeFeeStandardForm.amount = Number.parseFloat(standard.amount)
  }
  changeFeeStandardVisible.value = true
}

// 新增费率标准
const newFeeStandardVisible = ref(false)

const newFeeStandardForm = reactive({
  name: '',
  amount: 0.00
})

async function fetchNewFee() {
  await handleXhrResponse(() => addFeeStandard(newFeeStandardForm.amount, newFeeStandardForm.name), Message)
}

async function newFeeStandardFormHandleBeforeOk(done: (closed: boolean) => void) {
  await fetchNewFee()
  done(true)
  Message.success('新建成功')
  newFeeStandardForm.name = ''
  newFeeStandardForm.amount = 0.00
  await fetchFeeList()
}
</script>

<style scoped lang="less">

</style>
