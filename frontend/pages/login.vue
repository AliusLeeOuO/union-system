<template>
  登录
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
      <a-image :src="captchaPicture" show-loader :preview="false" :height="50" :width="120" @click="changeCaptcha"
               class="captcha" />
    </a-form-item>
    <!--    <a-form-item field="isRead" :rules="[{type:'boolean', true:true,message:'请先阅读并同意协议'}]">
          <a-checkbox v-model="form.isRead">
            我已阅读并同意协议
          </a-checkbox>
        </a-form-item>-->
    <a-form-item>
      <a-button html-type="submit">登录</a-button>
    </a-form-item>
  </a-form>
  {{ form }}
</template>
<script setup lang="ts">
import type { ValidatedError } from "@arco-design/web-vue"
import userService from "~/api/userService"
import { useUserStore } from "~/store/userStore"

const userStore = useUserStore()
const captchaPicture = ref("")

const form = reactive({
  username: "",
  password: "",
  captchaID: "",
  captchaVal: ""
  // isRead: true
})

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    try {
      const { data } = await userService().login(form.values.username, form.values.password, form.values.captchaID, form.values.captchaVal)
      console.log(data)

      // 保存token到localStorage
      localStorage.setItem("token", data.data.token)
      // 保存其它数据到pinia
      userStore.setUserInfo(data.data.role, data.data.status, data.data.userId, data.data.username)
      // TODO: 根据角色跳转到不同的页面
    } catch (error) {
      await changeCaptcha()
      console.log(error)
    }
  }
}

async function changeCaptcha() {
  try {
    const { data } = await userService().getCaptcha()
    captchaPicture.value = data.data.imagePath
    form.captchaID = data.data.captchaID
  } catch (error) {
    console.log(error)
  }
}

onMounted(async () => {
  await changeCaptcha()
})

</script>
<style scoped lang="less">
.captcha {
  cursor: pointer;
}
</style>