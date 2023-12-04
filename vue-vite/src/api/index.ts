import axios, { type AxiosResponse } from "axios"
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


export default axiosInstance

export interface AxiosApiResponse<T> extends AxiosResponse {
  data: ApiResponse<T>;
}

interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}


