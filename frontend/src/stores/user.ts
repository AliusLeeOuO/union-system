import { ref, reactive, computed } from "vue"
import { defineStore } from "pinia"
import useUserApi, { type permissionResponseData } from "@/api/userApi"

export const useUserStore = defineStore("user", () => {
  const userInfo = reactive({
    token: "",
    userId: -1,
    userName: "",
    userRole: -1,
    phone: "",
    email: ""
  })

  const isUserLoggedIn = computed(() => {
    return userInfo.token.length > 0
  })

  const getUserRoleName = computed(() => {
    switch (userInfo.userRole) {
      case 1:
        return "管理员"
      case 2:
        return "用户"
      default:
        return "未知"
    }
  })

  const userPermissions = ref<permissionResponseData[]>([])
  const fetchPermission = async () => {
    const userApi = useUserApi()
    const { data } = await userApi.getPermission()

    // 对获取的权限数据进行排序
    const sortedData = data.data.sort((a, b) => a.list_order - b.list_order)

    // 将排序后的数据放入 RBACNavListItem 数组中
    userPermissions.value.splice(0, userPermissions.value.length, ...sortedData)
  }

  function clearUserInfo() {
    userInfo.token = ""
    userInfo.userId = -1
    userInfo.userName = ""
    userInfo.userRole = -1
    userInfo.phone = ""
    userInfo.email = ""
    userPermissions.value.splice(0, userPermissions.value.length)
  }

  return {
    userInfo,
    isUserLoggedIn,
    getUserRoleName,
    clearUserInfo,
    userPermissions,
    fetchPermission
  }
}, {
  persist: {
    key: "user",
    storage: localStorage
  }
})
