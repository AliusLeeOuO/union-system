import { reactive, computed } from "vue"
import { defineStore } from "pinia"

export const useUserStore = defineStore("user", () => {
  const userInfo = reactive({
    token: "",
    userId: -1,
    userName: "",
    userRole: -1
  })

  function isUserLoggedIn() {
    return computed(() => userInfo.token.length > 0)
  }

  function getUserRoleName() {
    return computed(() => {
      switch (userInfo.userRole) {
        case 0:
          return "用户"
        case 1:
          return "财务"
        case 2:
          return "管理员"
      }
    })
  }

  return {
    userInfo,
    isUserLoggedIn,
    getUserRoleName
  }
}, {
  persist: {
    key: "user",
    storage: localStorage
  }
})