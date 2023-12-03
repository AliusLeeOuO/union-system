import { useUserStore } from "~/store/userStore"

export default defineNuxtRouteMiddleware(async (to, from) => {
  const userStore = useUserStore()
  // 检查token和用户信息是否存在
  const token = localStorage.getItem("token")
  const isUserInfoEmpty = userStore.isUserInfoEmpty
  const userRole = userStore.userInfo.role

  // 如果token不存在，跳转到登录页
  if (!token) {
    return navigateTo("/login")
  }

  // 如果用户信息不存在，获取用户信息
  if (isUserInfoEmpty) {
    await userStore.getUserInfo()
  }

  // 如果用户角色进入了不该进入的页面，跳转到404
  if (userRole === 2 && !to.path.startsWith("/manage")) {
    return navigateTo("/404")
  } else if (userRole === 0 && !to.path.startsWith("/user")) {
    return navigateTo("/404")
  } else if (userRole === 1 && !to.path.startsWith("/finance")) {
    return navigateTo("/404")
  }
})