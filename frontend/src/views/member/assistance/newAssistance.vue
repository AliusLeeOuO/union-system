<template>
  <a-form :model="newFormItem" layout="vertical" :rules="rules" @submit="submitRequest">
    <a-form-item field="type_id" label="请求类型" required>
      <a-radio-group v-model="newFormItem.type_id" type="button">
        <a-radio v-for="item in assistanceType" :key="item.assistance_type_id" :value="item.assistance_type_id">
          {{ item.type_name }}
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <a-form-item field="title" label="请求标题" :validate-trigger="['blur']">
      <a-input v-model="newFormItem.title" placeholder="输入请求标题" />
    </a-form-item>
    <a-form-item
      label="详细信息"
      validate-trigger="blur"
      field="description"
    >
      <a-textarea
        v-model="newFormItem.description"
        placeholder="在这里输入详细信息"
        :auto-size="{ minRows: 3 }"
      />
    </a-form-item>
    <div class="flex flex-col gap-2">
      <a-button type="primary" long size="large" html-type="submit">
        提交
      </a-button>
      <a-button long size="large" @click="handlerCloseDrawer">
        取消
      </a-button>
    </div>
  </a-form>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import { type FieldRule, Message, type ValidatedError } from '@arco-design/web-vue'
import type { assistanceTypeResponse } from '@/api/memberApi'
import { handleXhrResponse } from '@/api'
import useMemberApi from '@/api/memberApi'

const emits = defineEmits(['closeDrawer', 'successFetchNewAssistance'])
const memberApi = useMemberApi()

const rules: Record<string, FieldRule | FieldRule[]> = {
  type_id: [{
    required: true,
    message: '请选择请求类型',
    validator: (value, callback) => {
      return new Promise((resolve) => {
        if (value === -1) {
          callback('请选择请求类型')
        }

        resolve(void 0)
      })
    }
  }],
  title: [{ required: true, message: '请输入标题' }, { minLength: 5, message: '最少需要5个字符' }],
  description: [{ required: true, message: '请输入详细信息' }, { minLength: 10, message: '最少需要10个字符' }]
}

// 新建请求
const newFormItem = reactive({
  title: '',
  type_id: -1,
  description: ''
})
const assistanceType = reactive<assistanceTypeResponse[]>([])

async function getAssistanceType() {
  const { data } = await handleXhrResponse(() => memberApi.assistanceType(), Message)
  assistanceType.splice(0, assistanceType.length)
  assistanceType.push(...data.data)
}

async function submitRequest(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    const { data } = await handleXhrResponse(() => memberApi.assistanceNew(newFormItem.type_id, newFormItem.title, newFormItem.description), Message)
    Message.success('提交成功')
    emits('successFetchNewAssistance', data.data.request_id)
  }
}

onMounted(async () => {
  await getAssistanceType()
})

function handlerCloseDrawer() {
  emits('closeDrawer')
}
</script>

<style scoped lang="less">

</style>
