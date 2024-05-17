import qs from 'qs'
import type { AxiosApiResponse } from '@/api/index'
import axiosInstance from '@/api/index'

interface getCaptchaResponseData {
  captchaID: string
  imagePath: string
}

interface loginResponseData {
  role: number
  status: boolean
  token: string
  user_id: number
  username: string
  phone: string
  email: string
}

interface getUserInfoResponseData {
  role: number
  status: number
  userID: number
  username: string
  phone: string
  email: string
}

export interface permissionResponseData {
  permission_id: number
  permission_name: string
  description: string
  role_type: string
  permission_node: string
  gmt_create: string
  list_hidden: boolean
  list_order: number
  icon: string
  children?: permissionResponseData[]
}

export default function useUserApi() {
  return {
    getCaptcha: (): Promise<AxiosApiResponse<getCaptchaResponseData>> => axiosInstance.get('/user/getCaptcha'),
    login: (
      username: string,
      password: string,
      captchaId: string,
      captchaVal: string
    ): Promise<AxiosApiResponse<loginResponseData>> => axiosInstance.post('/user/login', qs.stringify({
      username,
      password,
      captcha_id: captchaId,
      captcha_val: captchaVal
    })),
    getUserInfo: (): Promise<AxiosApiResponse<getUserInfoResponseData>> => axiosInstance.get('/user/getUserInfo'),
    logout: (): Promise<AxiosApiResponse<null>> => axiosInstance.post('/user/logout'),
    changePassword: (oldPassword: string, newPassword: string): Promise<AxiosApiResponse<null>> => axiosInstance.post('/user/changePassword', qs.stringify({
      old_password: oldPassword,
      new_password: newPassword
    })),
    register: (
      username: string,
      password: string,
      phoneNumber: string,
      email: string,
      invitationCode: string
    ): Promise<AxiosApiResponse<null>> => axiosInstance.post('/user/register', qs.stringify({
      username,
      password,
      phone_number: phoneNumber,
      email,
      invitation_code: invitationCode
    })),
    getPermission: (): Promise<AxiosApiResponse<permissionResponseData[]>> => axiosInstance.get('/user/permission')
  }
}
