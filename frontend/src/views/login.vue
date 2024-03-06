<template>
  <div class="login-container">
    <div class="login-header">登录</div>
    <div class="login-form-container">
      <div>
        <a-form :model="form" :style="{width:'400px'}" @submit="handleSubmit">
          <a-form-item field="username" label="用户名" validate-trigger="input"
                       :rules="[{required:true,message:'请输入用户名'},{minLength:4,message:'用户名在4个字符以上'}]">
            <a-input v-model="form.username" />
          </a-form-item>
          <a-form-item field="password" label="密码" validate-trigger="input"
                       :rules="[{required:true,message:'请输入密码'},{minLength:6,message:'密码需要在6个字符以上'}]">
            <a-input-password v-model="form.password" />
          </a-form-item>
          <a-form-item field="captchaVal" label="验证码" validate-trigger="input"
                       :rules="[{required:true,message:'请输入验证码'},{minLength:4,message:'请输入完整的验证码'}]">
            <a-input v-model="form.captchaVal" :max-length="4" />
          </a-form-item>
          <a-form-item>
            <div class="captcha-block">
              <a-image :src="captchaPicture" show-loader :preview="false" :height="50" :width="120" @click="addCaptcha"
                       class="captcha" />
              <span class="change-captcha" @click="addCaptcha">点击更换验证码</span>
            </div>
          </a-form-item>
          <a-button type="primary" html-type="submit" long size="large" :loading="handleButtonLoading">登录</a-button>
        </a-form>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import { useRouter } from "vue-router"
import { useUserStore } from "@/stores/user"
import { handleXhrResponse } from "@/api"
import useUserApi from "@/api/userApi"
import { Message } from "@arco-design/web-vue"
import type { ValidatedError } from "@arco-design/web-vue"
import { roles } from "@/router"

const router = useRouter()
const userApi = useUserApi()
const userStore = useUserStore()

const captchaPicture = ref("")
const handleButtonLoading = ref(false)

const form = reactive({
  username: "",
  password: "",
  captchaID: "",
  captchaVal: ""
})

async function addCaptcha() {
  const { data } = await handleXhrResponse(() => userApi.getCaptcha(), Message)
  captchaPicture.value = data.data.imagePath
  form.captchaID = data.data.captchaID
}

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    handleButtonLoading.value = true
    try {
      const { data } = await handleXhrResponse(
        () => userApi.login(form.values.username, form.values.password, form.values.captchaID, form.values.captchaVal),
        Message
      )
      // 保存数据到pinia
      userStore.userInfo.token = data.data.token
      userStore.userInfo.userName = data.data.username
      userStore.userInfo.userId = data.data.user_id
      userStore.userInfo.userRole = data.data.role
      userStore.userInfo.phone = data.data.phone
      userStore.userInfo.email = data.data.email
      if (userStore.userInfo.userRole === roles.ADMIN) {
        // 跳转到管理员页面
        await router.push("/admin/index")
      } else if (userStore.userInfo.userRole === roles.USER) {
        // 跳转到用户页面
        await router.push("/member/index")
      }
    } finally {
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
.login-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #f5f5f5;
  background-image: url("@/assets/images/loginbg.jpg");
  background-size: cover;

  .login-header {
    font-size: 24px;
    color: #333;
    margin-bottom: 20px;
    // dark mode
    @media (prefers-color-scheme: dark) {
      color: rgba(0, 0, 0, 0.8);
    }
  }

  .login-form-container {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 500px;
    // dark mode
    @media (prefers-color-scheme: dark) {
      background-color: rgba(0, 0, 0, 0.8);
    }

    .captcha-block {
      .captcha {
        cursor: pointer;
      }

      .change-captcha {
        color: var(--color-text-2);
        cursor: pointer;
        transition: 0.3ms ease;
        margin-left: 10px;
        user-select: none;

        &:hover {
          color: var(--color-text-1);
        }
      }
    }
  }
}


</style>