import { reactive, computed } from "vue"
import { defineStore } from "pinia"

export const useUserStore = defineStore("user", () => {
  const userInfo = reactive({
    token: "",
    userId: -1,
    userName: "",
    userRole: -1
  })

  const isUserLoggedIn = computed(() => {
    return userInfo.token.length > 0
  })

  const getUserRoleName = computed(() => {
    switch (userInfo.userRole) {
      case 0:
        return "用户"
      case 1:
        return "管理员"
      case 2:
        return "管理员"
      default:
        return "未知"
    }
  })

  function clearUserInfo() {
    userInfo.token = ""
    userInfo.userId = -1
    userInfo.userName = ""
    userInfo.userRole = -1
  }

  return {
    userInfo,
    isUserLoggedIn,
    getUserRoleName,
    clearUserInfo
  }
}, {
  persist: {
    key: "user",
    storage: localStorage
  }
})