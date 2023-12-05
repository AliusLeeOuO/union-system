import axios, { AxiosError, type AxiosResponse } from "axios"
import { useUserStore } from "@/stores/user"

const API_URL: string = import.meta.env.VITE_API_URL || "/"

const axiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 10000
})

// 添加token到请求头
axiosInstance.interceptors.request.use(
  config => {
    const userStore = useUserStore()
    const token = userStore.userInfo.token
    if (token.length > 0) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 拦截响应，在http code = 400时如果token无效（code=1000）则跳转到登录页
axiosInstance.interceptors.response.use(
  (response: AxiosResponse) => {
    // 正常响应处理
    return response
  },
  (error: AxiosError) => {
    const userStore = useUserStore()
    // 使用类型断言来指定error.response.data的类型
    const responseData = error.response?.data as ApiResponse<any>
    if (responseData && responseData.code === 1000) {
      userStore.clearUserInfo()
    }
    return Promise.reject(error)
  }
)


export default axiosInstance

export interface AxiosApiResponse<T> extends AxiosResponse {
  data: ApiResponse<T>;
}

interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}


