<template>
  <div class="login-container flex flex-col justify-center flex-items-center bg-cover min-h-lvh">
    <div class="login-header">
      登录
    </div>
    <div class="login-form-container w-full flex justify-center flex-items-center">
      <div v-if="loginSuccessfully">
        <a-result status="success" title="登录成功" />
      </div>
      <div v-else>
        <a-form :model="form" :style="{ width: '400px' }" @submit="handleSubmit">
          <a-form-item
            field="username" label="用户名" validate-trigger="blur"
            :rules="[{ required: true, message: '请输入用户名' }]"
          >
            <a-input v-model="form.username" />
          </a-form-item>
          <a-form-item
            field="password" label="密码" validate-trigger="blur"
            :rules="[{ required: true, message: '请输入密码' }, { minLength: 6, message: '密码需要在6个字符以上' }]"
          >
            <a-input-password v-model="form.password" />
          </a-form-item>
          <a-form-item
            field="captchaVal" label="验证码" validate-trigger="blur"
            :rules="[{ required: true, message: '请输入验证码' }, { minLength: 4, message: '请输入完整的验证码' }]"
          >
            <a-input v-model="form.captchaVal" :max-length="4" />
          </a-form-item>
          <a-form-item>
            <div class="captcha-block">
              <a-image
                :src="captchaPicture" show-loader :preview="false" :height="50" :width="120" class="cursor-pointer"
                @click="addCaptcha"
              />
              <span class="change-captcha cursor-pointer select-none" @click="addCaptcha">点击更换验证码</span>
            </div>
          </a-form-item>
          <a-button type="primary" html-type="submit" long size="large" :loading="handleButtonLoading">
            登录
          </a-button>
        </a-form>
      </div>
    </div>
    <a-space v-if="!loginSuccessfully" class="prime-action flex justify-center flex-items-center">
      <router-link v-slot="{ navigate }" to="/register" custom>
        <a-link @click="navigate">
          注册用户
        </a-link>
      </router-link>
    </a-space>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Message } from '@arco-design/web-vue'
import type { ValidatedError } from '@arco-design/web-vue'
import { useUserStore } from '@/stores/user'
import { handleXhrResponse } from '@/api'
import useUserApi from '@/api/userApi'
import { roles } from '@/router'

const router = useRouter()
const userApi = useUserApi()
const userStore = useUserStore()

const captchaPicture = ref('')
const handleButtonLoading = ref(false)

const form = reactive({
  username: '',
  password: '',
  captchaID: '',
  captchaVal: ''
})

async function addCaptcha() {
  const { data } = await handleXhrResponse(() => userApi.getCaptcha(), Message)
  captchaPicture.value = data.data.imagePath
  form.captchaID = data.data.captchaID
}

const loginSuccessfully = ref(false)

async function handleSubmit(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    handleButtonLoading.value = true
    try {
      const { data } = await handleXhrResponse(
        () => userApi.login(form.values.username, form.values.password, form.values.captchaID, form.values.captchaVal),
        Message
      )
      loginSuccessfully.value = true
      // 保存数据到pinia
      userStore.userInfo.token = data.data.token
      userStore.userInfo.userName = data.data.username
      userStore.userInfo.userId = data.data.user_id
      userStore.userInfo.userRole = data.data.role
      userStore.userInfo.phone = data.data.phone
      userStore.userInfo.email = data.data.email
      await userStore.fetchPermission()
      setTimeout(async () => {
        if (userStore.userInfo.userRole === roles.ADMIN) {
          // 跳转到管理员页面
          await router.push('/admin/index')
        }
        else if (userStore.userInfo.userRole === roles.USER) {
          // 跳转到用户页面
          await router.push('/member/index')
        }
      }, 3000)
    }
    finally {
      handleButtonLoading.value = false
      await addCaptcha()
    }
  }
}

onMounted(async () => {
  await addCaptcha()
})
</script>

<style scoped lang="less">
body[arco-theme="dark"] {
  .login-container {
    .login-header {
      color: rgba(0, 0, 0, 0.8);
    }

    .login-form-container {
      background-color: rgba(0, 0, 0, 0.6);
    }
  }
}

.login-container {
  background-color: #f5f5f5;
  background-image: url("@/assets/images/loginbg.jpg");

  .login-header {
    font-size: 24px;
    color: #333;
    margin-bottom: 20px;
  }

  .login-form-container {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 40px 40px 20px 40px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    max-width: 500px;

    .captcha-block {

      .change-captcha {
        color: var(--color-text-2);
        transition: 0.3ms ease;
        margin-left: 10px;

        &:hover {
          color: var(--color-text-1);
        }
      }
    }
  }
}

.prime-action {
  margin-top: 10px;
}
</style>
