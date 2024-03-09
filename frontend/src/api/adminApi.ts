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

export interface getLoginLogResponseData {
  page_num: number
  page_size: number,
  total: number,
  data: loginLogItem[] | null
}

export interface loginLogItem {
  log_id: number
  ua: string
  ip: string
  status: boolean
  login_time: string
  username: string
}

export interface getAssistanceListResponseData {
  page_num: number
  page_size: number,
  total: number,
  assistance_status: assistanceStatus[]
  data: assistanceListItem[] | null
}

export interface assistanceStatus {
  status_id: number
  status_name: string
}

export interface assistanceListItem {
  id: number
  username: string
  user_id: number
  create_time: string
  assistance_type: {
    id: number
    name: string
  }
  title: string
  description: string
  status: number
}

export interface assistanceDetailResponse {
  id: number
  assistance_type: string
  title: string
  description: string
  created_at: string
  updated_at: string
  status: {
    id: number
    name: string
  }
  type: {
    assistance_type_id: number
    type_name: string
  }
  responses: assistanceDetailResponseData[]
}

export interface assistanceDetailResponseData {
  response_id: number
  responder_id: number
  response_text: string
  created_at: string
  username: string
}

export interface activityListResponseData {
  total: number
  page_size: number
  page_num: number
  data: activityListResponse[] | null
}

export interface activityListResponse {
  activityId: number
  title: string
  description: string
  startTime: string
  endTime: string
  location: string
  maxParticipants: number
  activityTypeId: number
  activityTypeName: string
  isActive: boolean
  registrationCount: number
}

export interface activityRegistrations {
  userId: number
  userName: string
  phone: string
  email: string
}

export interface activityManagementListResponse {
  activity: activityListResponse
  registrations: activityRegistrations[] | null
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
    },
    getLoginLog: (pageNum: number, pageSize: number, status: "all" | "true" | "false"): Promise<AxiosApiResponse<getLoginLogResponseData>> => {
      return axiosInstance.post("/admin/management/getLoginList", qs.stringify({
        page_num: pageNum,
        page_size: pageSize,
        status
      }))
    },
    getAssistanceList: (pageNum: number, pageSize: number, assistance_type_id?: number, id?: number): Promise<AxiosApiResponse<getAssistanceListResponseData>> => {
      const params: { assistance_type_id?: number, id?: number, page_num: number, page_size: number } = {
        assistance_type_id,
        id,
        page_num: pageNum,
        page_size: pageSize
      }
      if (params.assistance_type_id === undefined) delete params.assistance_type_id
      if (params.id === undefined) delete params.id
      return axiosInstance.post("/admin/assistance/requests", qs.stringify(params))
    },
    assistanceDetail: (assistanceId: number): Promise<AxiosApiResponse<assistanceDetailResponse>> =>
      axiosInstance.post(
        `/admin/assistance/viewAssistance`,
        qs.stringify({
          request_id: assistanceId
        })
      ),
    assistanceReply: (assistanceId: number, responseText: string, newStatusId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/assistance/replyAssistance", qs.stringify({
      request_id: assistanceId,
      response_text: responseText,
      new_status_id: newStatusId
    })),
    activityList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<activityListResponseData>> => axiosInstance.post("/admin/activity/list", qs.stringify({
        page_size: pageSize,
        page_num: pageNum
      })
    ),
    activityDetail: (activityId: number): Promise<AxiosApiResponse<activityManagementListResponse>> =>
      axiosInstance.get(`/admin/activity/detail/${activityId}`),
    cancelUserReg: (activityId: number, userId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/activity/cancelUserReg", qs.stringify({
      activity_id: activityId,
      user_id: userId
    })),
    dropActivity: (activityId: number, password: string): Promise<AxiosApiResponse<null>> => axiosInstance.post(`/admin/activity/delete/${activityId}`, qs.stringify({
      password
    }))
  }
}