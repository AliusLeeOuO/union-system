<template>
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
        <a-radio v-for="item in roleOptions" :key="item.value" :value="item.value">
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
    <a-form-item field="permission_group" label="权限组">
      <a-select v-model="formItem.permissionGroup" placeholder="权限组" :disabled="roleListLoading">
        <a-option :value="-1" disabled>
          请选择权限组
        </a-option>
        <a-option v-for="item in roleList" :key="item.type_id" :value="item.type_id">
          {{ item.description }}
        </a-option>
      </a-select>
    </a-form-item>
    <div class="flex flex-col gap-2">
      <a-button type="primary" html-type="submit" size="large" :loading="loadingSubmitNewUser" long>
        添加
      </a-button>
      <a-button size="large" long @click="handlerClose">
        取消
      </a-button>
    </div>
  </a-form>
</template>

<script setup lang="ts">
import { computed, defineEmits, reactive, ref, watch } from 'vue'
import { type FieldRule, Message, type ValidatedError } from '@arco-design/web-vue'
import { getRoleName, roles } from '@/utils/roleHelper'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type allowPermissionGroupResponse } from '@/api/adminApi'

const emit = defineEmits(['closeDrawer', 'successCreateUser'])
const adminApi = useAdminApi()

const roleOptions = computed(() => {
  return Object.keys(roles)
    .filter(key => Number.isNaN(Number(key)))
    .map(key => ({
      value: roles[key as keyof typeof roles], // 使用类型断言
      name: getRoleName(roles[key as keyof typeof roles]) // 使用类型断言
    }))
})

const formItem = reactive({
  username: '',
  password: '',
  reTypePassword: '',
  role: '',
  email: '',
  phone: '',
  permissionGroup: -1
})

const loadingSubmitNewUser = ref(false)

const rules: Record<string, FieldRule | FieldRule[]> = {
  username: [{ required: true, message: '请输入用户名' }],
  password: [{ required: true, message: '请输入密码' }],
  permission_group: [
    {
      required: true,
      message: '请选择权限组',
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (formItem.permissionGroup === -1) {
            callback('请选择权限组')
          }
          resolve(void 0)
        })
      }
    }
  ],
  reTypePassword: [
    { required: true, message: '请重复密码' },
    {
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value !== formItem.password) {
            callback('两次密码不一致')
          }
          resolve(void 0)
        })
      }
    }
  ],
  role: [
    {
      required: true,
      message: '请选择角色',
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (!value) {
            callback('请选择角色')
          }

          if (value !== roles.ADMIN && value !== roles.MEMBER) {
            callback('请选择正确的角色')
          }

          resolve(void 0)
        })
      }
    }
  ],
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
  ]
}

async function handleSubmit(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    try {
      loadingSubmitNewUser.value = true
      await handleXhrResponse(() => adminApi.addNewUser(
        formItem.username,
        formItem.password,
        formItem.permissionGroup,
        formItem.email,
        formItem.phone,
        formItem.role
      ), Message)
      Message.success('添加成功')
      emit('successCreateUser')
    }
    catch (error: any) {
      Message.error(error.message)
    }
    finally {
      loadingSubmitNewUser.value = false
    }
  }
}

watch(() => formItem.role, async (value: string) => {
  await fetchAllowPermissionGroup(value)
})

const roleListLoading = ref(false)
const roleList = reactive<allowPermissionGroupResponse[]>([])
async function fetchAllowPermissionGroup(groupName: string) {
  try {
    roleListLoading.value = true
    formItem.permissionGroup = -1
    const { data } = await handleXhrResponse(() => adminApi.getPermissionList(groupName), Message)
    roleList.splice(0, roleList.length, ...data.data)
  }
  catch (error: any) {
    Message.error(error.message)
  }
  finally {
    roleListLoading.value = false
  }
}

function handlerClose() {
  emit('closeDrawer')
}
</script>

<style scoped lang="less">

</style>
