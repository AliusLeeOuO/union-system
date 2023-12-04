import { reactive, computed } from "vue"
import { defineStore } from "pinia"

export const useUserStore = defineStore("user", () => {
  const userInfo = reactive({
    token: "",
    userId: -1,
    userName: "",
    userRole: -1
  })

  return {
    userInfo
  }
}, {
  persist: {
    key: "user",
    storage: localStorage
  }
})