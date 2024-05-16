import axios, { type AxiosError, type AxiosResponse } from 'axios'

import type { Message } from '@arco-design/web-vue'
import { useUserStore } from '@/stores/user'

const API_URL: string = import.meta.env.VITE_API_URL || '/'

const axiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 10000
})

// 添加token到请求头
axiosInstance.interceptors.request.use(
  (config) => {
    const userStore = useUserStore()
    const token = userStore.userInfo.token
    if (token.length > 0) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

axiosInstance.interceptors.response.use(
  (response: AxiosResponse) => {
    // 正常响应处理
    return response
  },
  (error: AxiosError) => {
    // 在http code = 400时如果token无效（code=1000）则跳转到登录页
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

export async function handleXhrResponse<T>(axiosRequest: () => Promise<AxiosApiResponse<T>>, handlerMessage: typeof Message): Promise<AxiosApiResponse<T>> {
  try {
    return await axiosRequest()
  }
  catch (error) {
    const axiosError = error as AxiosError<ApiResponse<T>>
    if (axiosError.response) {
      // 请求已发出，服务器以状态码响应
      console.error('Error', axiosError.response.status, axiosError.response.data.message)
      handlerMessage.error(axiosError.response.data.message)
    }
    else if (axiosError.request) {
      // 请求已发出，但没有收到响应
      console.error('No response from server')
      handlerMessage.error('服务器没有响应')
    }
    else {
      // 在设置请求时发生了一些问题
      console.error('Error', axiosError.message)
      handlerMessage.error(axiosError.message)
    }
    throw axiosError
  }
}

export interface AxiosApiResponse<T> extends AxiosResponse {
  data: ApiResponse<T>
}

interface ApiResponse<T> {
  code: number
  message: string
  data: T
}
