<template>
  <a-form :model="newFormItem" @submit="submitRequest" :label-col-props="{
        span: 2
      }" :wrapper-col-props="{
        span: 22
      }">
    <!--  TODO 这里验证逻辑不对  -->
    <a-form-item field="type_id" label="请求类型" required>
      <a-radio-group v-model="newFormItem.type_id" type="button">
        <a-radio :value="item.assistance_type_id" v-for="item in assistanceType" :key="item.assistance_type_id">
          {{ item.type_name }}
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <a-form-item field="title" label="请求标题"
                 :rules="[{required:true,message:'请输入标题'},{minLength:5,message:'最少需要5个字符'}]"
                 :validate-trigger="['change','input']"
    >
      <a-input v-model="newFormItem.title" placeholder="输入请求标题" />
    </a-form-item>
    <a-form-item label="详细信息"
                 validate-trigger="blur"
                 :rules="[{required:true,message:'请输入详细信息'}]"
                 field="description"
    >
      <a-textarea
        placeholder="在这里输入详细信息"
        :auto-size="{
              minRows: 3
            }"
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
import { Message, type ValidatedError } from "@arco-design/web-vue"
import useMemberApi from "@/api/memberApi"
import { useRouter } from "vue-router"

const router = useRouter()
const memberApi = useMemberApi()

// 新建请求
const newFormItem = reactive({
  title: "",
  type_id: 0,
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