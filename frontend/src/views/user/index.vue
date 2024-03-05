<template>
  <div class="user-info">
    <div>已登录账号：{{ userStore.userInfo.userName }} | 当前身份：{{ getRoleName(userStore.userInfo.userRole) }}</div>
  </div>
  <div class="user-center">
    <div class="user-center-title">账号信息</div>
    <div class="user-center-item">
      <div class="user-center-item-left">
        <div>用户名</div>
        <div>{{ userStore.userInfo.userName }}</div>
      </div>
      <div>
        <!--        <icon-pen-fill /> 编辑-->
      </div>
    </div>
    <div class="user-center-item">
      <div class="user-center-item-left">
        <div>角色</div>
        <div>{{ getRoleName(userStore.userInfo.userRole) }}</div>
      </div>
      <div>
        <!--        <icon-pen-fill /> 编辑-->
      </div>
    </div>
    <div class="user-center-item">
      <div class="user-center-item-left">
        <div>密码</div>
        <div v-if="!changePassword">******</div>
        <div class="user-center-form" v-else>
          <a-form :model="changePasswordForm" layout="inline" @submit="submitChangePassword">
            <a-form-item
              field="oldPassword"
              label="旧密码"
              validate-trigger="input"
              :rules="[{required:true,message:'请输入密码'},{minLength:6,message:'密码需要在6个字符以上'}]"
            >
              <a-input-password v-model="changePasswordForm.oldPassword" />
            </a-form-item>
            <a-form-item
              field="newPassword"
              label="新密码"
              validate-trigger="input"
              :rules="[{required:true,message:'请输入密码'},{minLength:6,message:'密码需要在6个字符以上'}]"
            >
              <a-input-password v-model="changePasswordForm.newPassword" />
            </a-form-item>
            <a-form-item
              field="confirmPassword"
              label="确认密码"
              validate-trigger="input"
              :rules="[{required:true,message:'请输入密码'},{minLength:6,message:'密码需要在6个字符以上'},{validator: conformValidator}]"
            >
              <a-input-password v-model="changePasswordForm.confirmPassword" />
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">确认修改</a-button>
            </a-form-item>
          </a-form>
        </div>
      </div>
      <div @click="changePassword = true" v-if="!changePassword">
        <a-button>
          <template #icon>
            <icon-pen-fill />
          </template>
          编辑
        </a-button>
      </div>
      <div @click="changePassword = false" v-else>
        <a-button>
          <template #icon>
            <icon-close />
          </template>
          取消
        </a-button>
      </div>
    </div>
    <div class="actions">
      <a-button @click="logout">退出登录</a-button>
    </div>
  </div>
</template>
<script setup lang="ts">
import { reactive, ref } from "vue"
import { IconPenFill, IconClose } from "@arco-design/web-vue/es/icon"
import { useUserStore } from "@/stores/user"
import { Message, type ValidatedError } from "@arco-design/web-vue"
import useUserApi from "@/api/userApi"
import { useRouter } from "vue-router"
import { handleXhrResponse } from "@/api"
import { getRoleName } from "@/utils/roleHelper"

const userStore = useUserStore()
const router = useRouter()
const userApi = useUserApi()

const changePassword = ref(false)
const changePasswordForm = reactive({
  oldPassword: "",
  newPassword: "",
  confirmPassword: ""
})
const submitChangePassword = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    // 提交修改密码
    try {
      await handleXhrResponse(() => userApi.changePassword(form.values.oldPassword, form.values.newPassword), Message)
      Message.success("修改密码成功")
      changePassword.value = false
      // 清空表单
      changePasswordForm.oldPassword = ""
      changePasswordForm.newPassword = ""
      changePasswordForm.confirmPassword = ""
    } catch (e) {
      console.warn(e)
    }
  }
}
// ( value: FieldValue | undefined, callback: (error?: string) => void ) => void
const conformValidator = (value: string, callback: (error?: string) => void) => {
  if (value !== changePasswordForm.newPassword) {
    callback("两次输入的密码不一致")
  } else {
    callback()
  }
}

const logout = async () => {
  try {
    await handleXhrResponse(() => userApi.logout(), Message)
    userStore.clearUserInfo()
    await router.push("/login")
  } catch (e) {
    console.log(e)
  }
}
</script>
<style scoped lang="less">
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
  // dark mode
  @media (prefers-color-scheme: dark) {
    background-color: #333;
    // 阴影
    box-shadow: 0 0 10px 0 #000;
  }

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