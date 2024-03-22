<template>
  <a-form :model="newFormItem" @submit="submitRequest" layout="vertical" :rules="rules">
    <a-form-item field="type_id" label="请求类型" required>
      <a-radio-group v-model="newFormItem.type_id" type="button">
        <a-radio :value="item.assistance_type_id" v-for="item in assistanceType" :key="item.assistance_type_id">
          {{ item.type_name }}
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <a-form-item field="title" label="请求标题" :validate-trigger="['blur']">
      <a-input v-model="newFormItem.title" placeholder="输入请求标题" />
    </a-form-item>
    <a-form-item label="详细信息"
                 validate-trigger="blur"
                 field="description"
    >
      <a-textarea
        placeholder="在这里输入详细信息"
        :auto-size="{ minRows: 3 }"
        v-model="newFormItem.description"
      />
    </a-form-item>
    <div>
      <a-button type="primary" long size="large" html-type="submit">提交</a-button>
    </div>
  </a-form>
</template>
<script setup lang="ts">
import { reactive, onMounted } from "vue"
import type { assistanceTypeResponse } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { type FieldRule, Message, type ValidatedError } from "@arco-design/web-vue"
import useMemberApi from "@/api/memberApi"
import { useRouter } from "vue-router"

const router = useRouter()
const memberApi = useMemberApi()

const rules: Record<string, FieldRule | FieldRule[]> = {
  type_id: [{
    required: true,
    message: "请选择请求类型",
    validator: (value, callback) => {
      return new Promise((resolve) => {
        if (value === -1) {
          callback("请选择请求类型")
        }
        resolve(void 0)
      })
    }
  }],
  title: [{ required: true, message: "请输入标题" }, { minLength: 5, message: "最少需要5个字符" }],
  description: [{ required: true, message: "请输入详细信息" }, { minLength: 10, message: "最少需要10个字符" }]
}

// 新建请求
const newFormItem = reactive({
  title: "",
  type_id: -1,
  description: ""
})
const assistanceType = reactive<assistanceTypeResponse[]>([])
const getAssistanceType = async () => {
  const { data } = await handleXhrResponse(() => memberApi.assistanceType(), Message)
  assistanceType.splice(0, assistanceType.length)
  assistanceType.push(...data.data)
}

const submitRequest = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    const { data } = await handleXhrResponse(() => memberApi.assistanceNew(newFormItem.type_id, newFormItem.title, newFormItem.description), Message)
    Message.success("提交成功")
    await router.push(`/member/assistanceDetail/${data.data.request_id}`)
  }
}

onMounted(async () => {
  await getAssistanceType()
})

</script>
<style scoped lang="less">

</style>