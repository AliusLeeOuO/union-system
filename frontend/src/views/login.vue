<template>
  <div class="login-container">
    <div class="login-header">登录</div>
    <div class="login-form-container">
      <!-- 原有的表单内容 -->
      <div>
        <a-form :model="form" :style="{width:'400px'}" @submit="handleSubmit">
          <a-form-item field="username" label="用户名" validate-trigger="input" required>
            <a-input v-model="form.username" />
          </a-form-item>
          <a-form-item field="password" label="密码" validate-trigger="input" required>
            <a-input-password v-model="form.password" />
          </a-form-item>
          <!--验证码-->
          <a-form-item field="captchaVal" label="验证码" validate-trigger="input" required>
            <a-input v-model="form.captchaVal" :max-length="4" />
          </a-form-item>
          <a-form-item>
            <div class="captcha-block">
              <a-image :src="captchaPicture" show-loader :preview="false" :height="50" :width="120" @click="addCaptcha"
                       class="captcha" />
              <span class="change-captcha" @click="addCaptcha">点击更换验证码</span>
            </div>
          </a-form-item>
          <a-button type="primary" html-type="submit" long size="large">登录</a-button>
        </a-form>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, reactive, getCurrentInstance, onMounted } from "vue"
import { useRouter } from "vue-router"
import { useUserStore } from "@/stores/user"
import useUserApi from "@/api/userApi"
import type { ValidatedError } from "@arco-design/web-vue"

const vueInstance = getCurrentInstance()
const router = useRouter()
const userApi = useUserApi()
const userStore = useUserStore()

const captchaPicture = ref("")
const form = reactive({
  username: "",
  password: "",
  captchaID: "",
  captchaVal: ""
})

async function addCaptcha() {
  try {
    const { data } = await userApi.getCaptcha()
    captchaPicture.value = data.data.imagePath
    form.captchaID = data.data.captchaID
  } catch (error) {
    console.log(error)
  }
}

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    try {
      const { data } = await userApi.login(form.values.username, form.values.password, form.values.captchaID, form.values.captchaVal)
      // 保存数据到pinia
      userStore.userInfo.token = data.data.token
      userStore.userInfo.userName = data.data.username
      userStore.userInfo.userId = data.data.userId
      userStore.userInfo.userRole = data.data.role
      // TODO: 根据角色跳转到不同的页面
      if (userStore.userInfo.userRole === 2) {
        // 跳转到管理员页面
        await router.push("/admin/index")
      }
    } catch (error: any) {
      await addCaptcha()
      console.log(error)
      vueInstance!.appContext.config.globalProperties.$message.error(error.response.data.message)
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
  @media (max-width: 600px) {
    padding: 20px;
    max-width: 100%;
  }
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