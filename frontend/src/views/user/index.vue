<template>
  <div class="grid gap-2">
    <a-card>
      <div class="flex gap-2 font-size-6">
        <span>Hi, {{ userStore.userInfo.userName }} {{ getRoleName(userStore.userInfo.userRole) }} !</span>
        <span v-if="new Date().getHours() < 12">早上好</span>
        <span v-else-if="new Date().getHours() < 14">中午好</span>
        <span v-else-if="new Date().getHours() < 18">下午好</span>
        <span v-else>晚上好</span>
        !
      </div>
    </a-card>
    <a-card title="个人信息">
      <a-descriptions
        :data="personalData"
        size="large"
        layout="vertical"
        :column="2"
        :label-style="{
          fontSize: '1rem',
          lineHeight: '1',
        }"
        :value-style="{
          fontSize: '1.2rem',
          lineHeight: '1',
        }"
      />
    </a-card>
    <a-card>
      <a-space>
        <a-button @click="showChangePasswordModal">
          修改密码
        </a-button>
        <a-button @click="logout">
          退出登录
        </a-button>
      </a-space>
    </a-card>
  </div>
  <a-modal v-model:visible="changePassword" @before-ok="submitChangePasswordNew">
    <template #title>
      修改密码
    </template>
    <a-form ref="changePasswordRef" :model="changePasswordForm">
      <a-form-item
        field="oldPassword"
        label="旧密码"
        validate-trigger="blur"
        :rules="[{ required: true, message: '请输入密码' }, { minLength: 6, message: '密码需要在6个字符以上' }]"
      >
        <a-input-password v-model="changePasswordForm.oldPassword" />
      </a-form-item>
      <a-form-item
        field="newPassword"
        label="新密码"
        validate-trigger="blur"
        :rules="[{ required: true, message: '请输入密码' }, { minLength: 6, message: '密码需要在6个字符以上' }]"
      >
        <a-input-password v-model="changePasswordForm.newPassword" />
      </a-form-item>
      <a-form-item
        field="confirmPassword"
        label="确认密码"
        validate-trigger="blur"
        :rules="[{ required: true, message: '请输入密码' }, { minLength: 6, message: '密码需要在6个字符以上' }, { validator: conformValidator }]"
      >
        <a-input-password v-model="changePasswordForm.confirmPassword" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { type FormInstance, Message } from '@arco-design/web-vue'

import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import useUserApi from '@/api/userApi'
import { handleXhrResponse } from '@/api'
import { getRoleName } from '@/utils/roleHelper'

const userStore = useUserStore()
const router = useRouter()
const userApi = useUserApi()

const changePassword = ref(false)
const changePasswordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

function showChangePasswordModal() {
  changePassword.value = true
}

// ( value: FieldValue | undefined, callback: (error?: string) => void ) => void
function conformValidator(value: string, callback: (error?: string) => void) {
  if (value !== changePasswordForm.newPassword) {
    callback('两次输入的密码不一致')
  }
  else {
    callback()
  }
}

async function logout() {
  try {
    await handleXhrResponse(() => userApi.logout(), Message)
    userStore.clearUserInfo()
    await router.push('/login')
  }
  catch (e) {
    console.log(e)
  }
}

const personalData = [
  {
    label: '用户名',
    value: userStore.userInfo.userName
  },
  {
    label: '角色',
    value: getRoleName(userStore.userInfo.userRole)
  },
  {
    label: '邮箱',
    value: userStore.userInfo.email
  },
  {
    label: '手机号',
    value: userStore.userInfo.phone
  }
]
const changePasswordRef = ref<FormInstance | null>(null)

async function submitChangePasswordNew(done: (closed: boolean) => void) {
  const res = await changePasswordRef.value?.validate()
  if (res !== undefined) {
    done(false)
  }
  await handleXhrResponse(() => userApi.changePassword(changePasswordForm.oldPassword, changePasswordForm.newPassword), Message)
  Message.success('修改密码成功')
  done(true)
  changePasswordRef.value?.resetFields()
}
</script>

<style scoped lang="less">
body[arco-theme="dark"] {
  .user-center {
    background-color: #333;
    box-shadow: 0 0 10px 0 #000;
  }
}

.user-info {
  text-align: center;
  font-size: 20px;
  line-height: 28px;
}

.user-center {
  margin-top: 20px;
  padding: 20px;
  background-color: #f5f5f5;
  color: rgb(var(--color-text-1));
  border-radius: 10px;

  .user-center-title {
    font-size: 18px;
    margin-bottom: 20px;
  }

  .user-center-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #000;
    padding: 10px 10px;
    font-size: 16px;
    min-height: 65px;
    flex-wrap: wrap;

    .user-center-item-left {
      display: flex;
      flex: 1;
      align-items: center;

      & > :first-child {
        width: 100px;
      }

      .user-center-form {
        display: flex;
        align-items: center;
        flex: 1;

        :deep(.arco-form) {
          .arco-form-item {
            margin-top: 5px;
            margin-bottom: 5px;
          }
        }
      }
    }

    & > :last-child {
      cursor: pointer;
      padding-left: 20px;
      // 如果屏幕宽度小，则换行
      @media (max-width: 768px) {
        width: 100%;
        padding-left: 0;
        margin-top: 10px;
      }
    }
  }

  .actions {
    margin-top: 20px;
  }
}
</style>

<style>

</style>
