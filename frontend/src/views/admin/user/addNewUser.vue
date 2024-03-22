<template>
  <a-typography-title :heading="2">
    添加新用户
  </a-typography-title>
  <a-form
    :model="formItem"
    :rules="rules"
    layout="vertical"
    @submit="handleSubmit"
  >
    <a-form-item field="username" label="用户名">
      <a-input v-model="formItem.username" />
    </a-form-item>
    <a-form-item field="password" label="密码">
      <a-input-password v-model="formItem.password" />
    </a-form-item>
    <a-form-item field="reTypePassword" label="重复密码">
      <a-input-password v-model="formItem.reTypePassword" />
    </a-form-item>
    <a-form-item field="role" label="角色">
      <a-radio-group v-model="formItem.role" type="button">
        <a-radio :value="item.value" v-for="item in roleOptions" :key="item.value">
          {{ item.name }}
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <a-form-item field="email" label="邮箱">
      <a-input v-model="formItem.email" />
    </a-form-item>
    <a-form-item field="phone" label="手机号">
      <a-input v-model="formItem.phone" />
    </a-form-item>
    <div>
      <a-button type="primary" html-type="submit" size="large" long>添加</a-button>
    </div>
  </a-form>
</template>
<script setup lang="ts">
import { reactive, computed } from "vue"
import { roles, getRoleName } from "@/utils/roleHelper"
import { type FieldRule, Message, type ValidatedError } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import {useRouter} from "vue-router"
import useAdminApi from "@/api/adminApi"

const router = useRouter()
const adminApi = useAdminApi()

const roleOptions = computed(() => {
  return Object.keys(roles)
    .filter(key => isNaN(Number(key)))
    .map(key => ({
      value: roles[key as keyof typeof roles], // 使用类型断言
      name: getRoleName(roles[key as keyof typeof roles]) // 使用类型断言
    }))
})


const formItem = reactive({
  username: "",
  password: "",
  reTypePassword: "",
  role: -1,
  email: "",
  phone: ""
})

const rules: Record<string, FieldRule | FieldRule[]> = {
  username: [{ required: true, message: "请输入用户名" }],
  password: [{ required: true, message: "请输入密码" }],
  reTypePassword: [
    { required: true, message: "请重复密码" },
    {
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value !== formItem.password) {
            callback("两次密码不一致")
          }
          resolve(void 0)
        })
      }
    }
  ],
  role: [
    {
      required: true, message: "请选择角色",
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (!value) {
            callback("请选择角色")
          }
          if (value !== roles.ADMIN && value !== roles.USER) {
            callback("请选择正确的角色")
          }
          resolve(void 0)
        })
      }
    }
  ],
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
  ]
}

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    await handleXhrResponse(() => adminApi.addNewUser(
      form.values.username,
      form.values.password,
      form.values.role,
      form.values.email,
      form.values.phone
    ), Message)
    Message.success("添加成功")
    await router.push("/admin/manageUser")
  }
}

</script>
<style scoped lang="less">

</style>