import { defineStore } from "pinia"

export const useUserStore = defineStore("userStore", () => {
  const userInfo = reactive({
    role: 0,
    status: 0,
    userId: -1,
    username: ""
  })

  const setUserInfo = (role: number, status: number, userId: number, username: string) => {
    userInfo.role = role
    userInfo.status = status
    userInfo.userId = userId
    userInfo.username = username
  }

  const clearUserInfo = () => {
    userInfo.role = 0
    userInfo.status = 0
    userInfo.userId = -1
    userInfo.username = ""
  }

  const isUserInfoEmpty = computed(() => {
    return userInfo.role === 0 && userInfo.status === 0 && userInfo.userId === -1 && userInfo.username === ""
  })

  const getUserInfo = async () => {

  }

  return {
    userInfo,
    setUserInfo,
    clearUserInfo,
    isUserInfoEmpty,
    getUserInfo
  }
})