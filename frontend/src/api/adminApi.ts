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
      return axiosInstance.post("/admin/getUserList", qs.stringify(params))
    }
  }
}