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

export interface invitationCodeListResponse {
  page_size: number
  page_num: number
  total: number
  data: invitationCodeListItem[] | null
}

export interface invitationCodeListItem {
  code_id: number
  code: string
  created_by_user_id: number
  used_by_user_id: string
  is_used: boolean
  created_at: string
  expires_at: string
}

export interface generateInvitationCodeResponse {
  code_id: number
  code: string
  created_at: string
  expires_at: string
}

export interface createActivityResponse {
  success: boolean
  id: number
  message: string
}

export interface activityType {
  activity_type_id: number
  type_name: string
}

export interface getLogAdminListResponse {
  page_size: number
  page_num: number
  total: number
  data: logAdminListItem[] | null
}

export interface logAdminListItem {
  log_id: number
  user: {
    id: number
    username: string
  }
  action: {
    id: number
    name: string
  }
  detail: string
  ip: string
  time: string
}

export interface getLogMemberListResponse {
  page_size: number
  page_num: number
  total: number
  data: logMemberListItem[] | null
}

export interface logMemberListItem {
  log_id: number
  user: {
    id: number
    username: string
  }
  action: {
    id: number
    name: string
  }
  detail: string
  ip: string
  time: string
}

export interface getRegisteredFeeList {
  page_num: number
  page_size: number
  total: number
  users: registeredFeeListItem[] | null
}

export interface registeredFeeListItem {
  user_id: number
  username: string
  email: string
  phone_number: string
  registration_date: string
  fee_amount: string
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
    addNewActivity: (
      title: string,
      description: string,
      start_time: string,
      end_time: string,
      location: string,
      type: number,
      max_participants: number,
      is_active: boolean
    ): Promise<AxiosApiResponse<createActivityResponse>> => axiosInstance.post("/admin/activity/create", qs.stringify({
      title,
      description,
      start_time,
      end_time,
      location,
      type,
      max_participants,
      is_active
    })),
    getActivityTypes: (): Promise<AxiosApiResponse<activityType[]>> => axiosInstance.get("/admin/activity/type"),
    modifyActivityTitle: (activityId: number, title: string): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/activity/modifyTitle", qs.stringify({
      activity_id: activityId,
      title
    })),
    modifyActivityDescription: (activityId: number, description: string): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/activity/modifyDescription", qs.stringify({
        activity_id: activityId,
        description
      })
    ),
    modifyActivityLocation: (activityId: number, location: string): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/activity/modifyLocation", qs.stringify({
      activity_id: activityId,
      location
    })),
    cancelUserReg: (activityId: number, userId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post("/admin/activity/cancelUserReg", qs.stringify({
      activity_id: activityId,
      user_id: userId
    })),
    dropActivity: (activityId: number, password: string): Promise<AxiosApiResponse<null>> => axiosInstance.post(`/admin/activity/delete/${activityId}`, qs.stringify({
      password
    })),
    getInvitationCodeList: (pageNum: number, pageSize: number): Promise<AxiosApiResponse<invitationCodeListResponse>> => axiosInstance.post("/admin/management/getInvitationCodeList", qs.stringify({
      page_num: pageNum,
      page_size: pageSize
    })),
    generateInvitationCode: (): Promise<AxiosApiResponse<generateInvitationCodeResponse>> => axiosInstance.post("/admin/management/generateInvitationCode"),
    getLogAdminList: (pageNum: number, pageSize: number): Promise<AxiosApiResponse<getLogAdminListResponse>> => axiosInstance.post("/admin/management/getLogAdminList", qs.stringify({
      page_num: pageNum,
      page_size: pageSize
    })),
    getLogMemberList(pageNum: number, pageSize: number): Promise<AxiosApiResponse<getLogMemberListResponse>> {
      return axiosInstance.post("/admin/management/getLogMemberList", qs.stringify({
        page_num: pageNum,
        page_size: pageSize
      }))
    },
    getRegisteredFeeList: (pageNum: number, pageSize: number): Promise<AxiosApiResponse<getRegisteredFeeList>> => axiosInstance.post("/admin/fee/getRegisteredFeeList", qs.stringify({
      page_num: pageNum,
      page_size: pageSize
    }))
  }
}
