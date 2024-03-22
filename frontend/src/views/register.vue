<template>
  <div class="login-container">
    <div class="login-header">注册</div>

    <div class="login-form-container">
      <div v-if="registerSuccessfully">
        <a-result status="success" title="注册成功" />
      </div>
      <div v-else>
        <a-form :model="registerForm" :style="{width:'400px'}" :rules="rules" @submit="handleSubmit" :label-col-props="{
        span: 6
      }" :wrapper-col-props="{
        span: 18
      }">
          <a-form-item field="username" label="用户名" validate-trigger="blur">
            <a-input v-model="registerForm.username" />
          </a-form-item>
          <a-form-item field="password" label="密码" validate-trigger="blur">
            <a-input-password v-model="registerForm.password" />
          </a-form-item>
          <a-form-item field="reTypePassword" label="重复密码" validate-trigger="blur">
            <a-input v-model="registerForm.reTypePassword" />
          </a-form-item>
          <a-form-item field="email" label="邮箱" validate-trigger="blur">
            <a-input v-model="registerForm.email" />
          </a-form-item>
          <a-form-item field="phone" label="手机号" validate-trigger="blur">
            <a-input v-model="registerForm.phone" />
          </a-form-item>
          <a-form-item field="invitationCode" label="邀请码" validate-trigger="blur">
            <a-input v-model="registerForm.invitationCode" />
          </a-form-item>
          <a-button type="primary" html-type="submit" long size="large" :loading="handleButtonLoading">注册</a-button>
        </a-form>
      </div>
    </div>
    <a-space class="prime-action">
      <router-link to="/login" custom v-slot="{ navigate }">
        <a-link @click="navigate">返回到登录</a-link>
      </router-link>
    </a-space>
  </div>
</template>
<script setup lang="ts">
import { ref, reactive } from "vue"
import { useRouter } from "vue-router"
import { handleXhrResponse } from "@/api"
import useUserApi from "@/api/userApi"
import { type FieldRule, Message } from "@arco-design/web-vue"
import type { ValidatedError } from "@arco-design/web-vue"


const router = useRouter()
const userApi = useUserApi()
const handleButtonLoading = ref(false)

const registerForm = reactive({
  username: "",
  password: "",
  reTypePassword: "",
  email: "",
  phone: "",
  invitationCode: ""
})

const rules: Record<string, FieldRule | FieldRule[]> = {
  username: [{ required: true, message: "请输入用户名" }],
  password: [{ required: true, message: "请输入密码" }],
  reTypePassword: [
    { required: true, message: "请重复密码" },
    {
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value !== registerForm.password) {
            callback("两次密码不一致")
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
  ],
  invitationCode: [{ required: true, message: "请输入邀请码" }]
}

const registerSuccessfully = ref(false)

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    handleButtonLoading.value = true
    try {
      await handleXhrResponse(() => userApi.register(registerForm.username, registerForm.password, registerForm.phone, registerForm.email, registerForm.invitationCode), Message)
      registerSuccessfully.value = true
      setTimeout(async () => {
        await router.push("/login")
      }, 3000)
    } finally {
      handleButtonLoading.value = false
    }
  }
}


</script>
<style scoped lang="less">
body[arco-theme="dark"] {
  .login-container {
    .login-header {
      color: rgba(0, 0, 0, 0.8);
    }
    .login-form-container {
      background-color: rgba(0, 0, 0, 0.8);
    }
  }
}


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
  }

  .login-form-container {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 40px 40px 20px 40px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 500px;
    display: flex;
    justify-content: center;
    align-items: center;

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

.prime-action {
  margin-top: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}

</style>