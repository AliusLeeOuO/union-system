<template>
  <a-typography-title :heading="2">
    修改用户
  </a-typography-title>
  <a-descriptions style="margin-top: 20px" :data="descInfo" size="large" title="用户信息" :column="1" />
  <a-form :model="formItem" :rules="rules" :label-col-props="{
    span: 2
  }" :wrapper-col-props="{
    span: 22
  }" @submit="handleSubmit">
    <a-form-item field="username" label="用户名">
      <a-input v-model="formItem.username" />
    </a-form-item>
    <a-form-item field="password" label="密码">
      <a-input-password v-model="formItem.password" placeholder="如果不需要修改密码，请留空。" />
    </a-form-item>
    <a-form-item field="email" label="邮箱">
      <a-input v-model="formItem.email" />
    </a-form-item>
    <a-form-item field="phone" label="手机号">
      <a-input v-model="formItem.phone" />
    </a-form-item>
    <a-form-item field="status" label="账号状态">
      <a-radio-group v-model="formItem.status" type="button">
        <a-radio :value="true">正常</a-radio>
        <a-radio :value="false">冻结</a-radio>
      </a-radio-group>
    </a-form-item>
    <div>
      <a-button type="primary" html-type="submit" size="large" long>修改</a-button>
    </div>
  </a-form>
</template>
<script setup lang="ts">
import { reactive, onMounted } from "vue"
import { getRoleName } from "@/utils/roleHelper"
import { type FieldRule, Message, type ValidatedError, type DescData } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import { useRoute } from "vue-router"
import useAdminApi from "@/api/adminApi"

const route = useRoute()
const adminApi = useAdminApi()

const solidInfo = reactive({
  id: route.params.id,
  role: -1
})

const descInfo = reactive<DescData[]>([
  {
    label: "用户ID",
    value: () => solidInfo.id.toString(), // Assuming id is numeric and needs to be string
  },
  {
    label: "角色",
    value: () => getRoleName(solidInfo.role), // Use a function to defer evaluation
  }
]);

const formItem = reactive({
  username: "",
  password: "",
  email: "",
  phone: "",
  status: false
})

const rules: Record<string, FieldRule | FieldRule[]> = {
  username: [{ required: true, message: "请输入用户名" }],
  email: [{ required: true, type: "email", message: "请输入正确的邮箱" }],
  phone: [
    {
      required: true,
      message: "请输入正确的手机号",
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (!/^1[3-9]\d{9}$/.test(value)) {
            callback("请输入正确的手机号")
          }
          resolve(void 0)
        })
      }
    }
  ],
  status: [
    {
      required: true,
      message: "请选择账号状态",
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value === true || value === false) {
            resolve(void 0)
          } else {
            callback("请选择账号状态")
          }
        })
      }
    }
  ]
}

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    if (form.values.password === "") {
      await handleXhrResponse(() => adminApi.updateUser(parseInt(route.params.id as string), formItem.username, formItem.status, formItem.phone, formItem.email), Message)
    } else {
      await handleXhrResponse(() => adminApi.updateUser(parseInt(route.params.id as string), formItem.username, formItem.status, formItem.phone, formItem.email, formItem.password), Message)
    }
    Message.success("修改成功")
    await fetchUserInfo()
  }
}

const fetchUserInfo = async () => {
  const userID = parseInt(route.params.id as string)
  const { data } = await handleXhrResponse(() => adminApi.getUserInfo(userID), Message)
  formItem.username = data.data.username
  formItem.email = data.data.email
  formItem.phone = data.data.phone
  formItem.status = data.data.status

  solidInfo.role = data.data.role
}

onMounted(async () => {
  await fetchUserInfo()
})

</script>
<style scoped lang="less"></style>