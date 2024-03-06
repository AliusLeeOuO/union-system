import type { AxiosApiResponse } from "@/api/index"
import axiosInstance from "@/api/index"
import qs from "qs"

export interface getUserResponseData {
  page_num: number
  page_size: number,
  total: number,
  data: userListItem[] | null
}

export interface userListItem {
  id: number
  role: number
  status: number
  username: string
  create_time: string
}

export interface userDetail {
  user_id: number
  username: string
  role: number
  status: boolean
  phone: string
  email: string
}

export default function useAdminApi() {
  return {
    getUserList: (pageNum: number, pageSize: number, id: number = -1, username: string = "", role: number = -1): Promise<AxiosApiResponse<getUserResponseData>> => {
      const params: { id?: number, username?: string, role?: number, page_num: number, page_size: number } = {
        id,
        username,
        role,
        page_num: pageNum,
        page_size: pageSize
      }
      if (params.id === -1) delete params.id
      if (params.username === "") delete params.username
      if (params.role === -1) delete params.role
      return axiosInstance.post("/admin/management/getUserList", qs.stringify(params))
    },
    addNewUser: (username: string, password: string, role: number, email: string, phone: number): Promise<AxiosApiResponse<null>> => {
      return axiosInstance.post("/admin/management/addNewUser", qs.stringify({
        username,
        password,
        role,
        email,
        phone
      }))
    },
    getUserInfo: (user_id: number): Promise<AxiosApiResponse<userDetail>> => {
      return axiosInstance.post("/admin/management/getUserInfo", qs.stringify({ user_id }))
    },
    updateUser: (user_id: number, username: string, status: boolean, phone: string, email: string, password?: string): Promise<AxiosApiResponse<null>> => {
      const params: {
        user_id: number,
        username: string,
        status: boolean,
        phone: string,
        email: string,
        password?: string
      } = {
        user_id,
        username,
        status,
        phone,
        email
      }
      if (password) params.password = password
      return axiosInstance.post("/admin/management/updateUser", qs.stringify(params))
    }
  }
}