<template>
  <a-descriptions :data="descInfo" size="large" title="用户信息" :column="1" />
  <a-form
    :model="formItem" :rules="rules" :label-col-props="{
      span: 4,
    }" :wrapper-col-props="{
      span: 20,
    }" @submit="handleSubmit"
  >
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
    <a-form-item field="role" label="权限组">
      <a-select v-model="formItem.role" placeholder="权限组">
        <a-option :value="-1" disabled>
          请选择权限组
        </a-option>
        <a-option v-for="item in roleList" :key="item.type_id" :value="item.type_id">
          {{ item.description }}
        </a-option>
      </a-select>
    </a-form-item>
    <a-form-item field="status" label="账号状态">
      <a-radio-group v-model="formItem.status" type="button">
        <a-radio :value="true">
          正常
        </a-radio>
        <a-radio :value="false">
          冻结
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <div>
      <a-button type="primary" html-type="submit" size="large" long>
        修改
      </a-button>
    </div>
  </a-form>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import { type DescData, type FieldRule, Message, type ValidatedError } from '@arco-design/web-vue'
import { useRoute } from 'vue-router'
import { getRoleName } from '@/utils/roleHelper'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type allowPermissionGroupResponse } from '@/api/adminApi'

const props = defineProps<{
  userId: number
}>()

const emit = defineEmits(['closeDrawer', 'successModifyUser'])

const route = useRoute()
const adminApi = useAdminApi()

const solidInfo = reactive({
  id: route.params.id,
  accountType: ''
})

const descInfo = reactive<DescData[]>([
  {
    label: '用户ID',
    value: () => props.userId
  },
  {
    label: '角色',
    value: () => getRoleName(solidInfo.accountType)
  }
])

const formItem = reactive({
  username: '',
  password: '',
  email: '',
  phone: '',
  status: false,
  role: -1
})

const rules: Record<string, FieldRule | FieldRule[]> = {
  username: [{ required: true, message: '请输入用户名' }],
  email: [{ required: true, type: 'email', message: '请输入正确的邮箱' }],
  phone: [
    {
      required: true,
      message: '请输入正确的手机号',
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (!/^1[3-9]\d{9}$/.test(value)) {
            callback('请输入正确的手机号')
          }

          resolve(void 0)
        })
      }
    }
  ],
  role: [
    {
      required: true,
      message: '请选择权限组',
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value !== -1) {
            resolve(void 0)
          }
          else {
            callback('请选择权限组')
          }
        })
      }
    }
  ],
  status: [
    {
      required: true,
      message: '请选择账号状态',
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value === true || value === false) {
            resolve(void 0)
          }
          else {
            callback('请选择账号状态')
          }
        })
      }
    }
  ]
}

async function handleSubmit(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    if (form.values.password === '') {
      await handleXhrResponse(() => adminApi.updateUser(props.userId, formItem.username, formItem.status, formItem.phone, formItem.email, formItem.role), Message)
    }
    else {
      await handleXhrResponse(() => adminApi.updateUser(props.userId, formItem.username, formItem.status, formItem.phone, formItem.email, formItem.role, formItem.password), Message)
    }
    Message.success('修改成功')
    emit('successModifyUser')
  }
}

async function fetchUserInfo() {
  const { data } = await handleXhrResponse(() => adminApi.getUserInfo(props.userId), Message)
  formItem.username = data.data.username
  formItem.email = data.data.email
  formItem.phone = data.data.phone
  formItem.status = data.data.status
  formItem.role = data.data.role
  solidInfo.accountType = data.data.account_type
}

// 获取可选权限组
const roleList = reactive<allowPermissionGroupResponse[]>([])

async function fetchRoleList() {
  const { data } = await handleXhrResponse(() => adminApi.getPermissionList(props.userId), Message)
  roleList.splice(0, roleList.length, ...data.data)
}

onMounted(async () => {
  await fetchUserInfo()
  await fetchRoleList()
})
</script>

<style scoped lang="less"></style>
