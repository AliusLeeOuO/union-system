import axiosInstance from "@/api/index"
import type { AxiosApiResponse } from "@/api/index"
import qs from "qs"

export interface activityListResponseData {
  total: number
  page_size: number
  page_num: number
  data: activityListResponse[]
}

interface activityListResponse {
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

// 会员援助列表
export interface assistanceListResponseData {
  total: number
  page_size: number
  page_num: number
  assistances: assistanceListResponse[]
}

export interface assistanceListResponse {
  title: string
  assistance_id: number
  description: string
  request_date: string
  assistance_type_id: number
  assistance_type: string
  status_id: number
  status: string
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
}

export interface assistanceTypeResponse {
  assistance_type_id: number
  type_name: string
}

export interface assistanceNewResponse {
  request_id: number
}

export default function useMemberApi() {
  return {
    activityList: (pageSize: number, pageNum: number): Promise<AxiosApiResponse<activityListResponseData>> => axiosInstance.post("/member/activity/list", qs.stringify({
      page_size: pageSize,
      page_num: pageNum
    })),
    activityDetail: (activityId: number): Promise<AxiosApiResponse<activityListResponse>> => axiosInstance.get(`/member/activity/detail/${activityId}`),
    activityRegister: (activityId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post(`/member/activity/register/${activityId}`),
    activityCancel: (activityId: number): Promise<AxiosApiResponse<null>> => axiosInstance.delete(`/member/activity/cancel/${activityId}`),
    // TODO:类型没写
    activityRegList: (pageSize: number, pageNum: number): Promise<AxiosApiResponse<any>> => axiosInstance.post("/member/history", qs.stringify({
      page_size: pageSize,
      page_num: pageNum
    })),
    activityType: (): Promise<AxiosApiResponse<any>> => axiosInstance.get("/member/type"),
    assistanceList: (pageSize: number, pageNum: number): Promise<AxiosApiResponse<assistanceListResponseData>> => axiosInstance.post("/member/assistance/list", qs.stringify({
      page_size: pageSize,
      page_num: pageNum
    })),
    assistanceDetail: (assistanceId: number): Promise<AxiosApiResponse<assistanceDetailResponse>> => axiosInstance.post(`/member/assistance/view`, qs.stringify({
      request_id: assistanceId
    })),
    assistanceReply: (requestId: number, responseText: string): Promise<AxiosApiResponse<null>> => axiosInstance.post("/member/assistance/reply", qs.stringify({
      request_id: requestId,
      response_text: responseText
    })),
    assistanceClose: (requestId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post("/member/assistance/close", qs.stringify({
      request_id: requestId
    })),
    assistanceType: (): Promise<AxiosApiResponse<assistanceTypeResponse[]>> => axiosInstance.get("/member/assistance/type"),
    assistanceNew: (assistanceTypeId: number, title: string, description: string): Promise<AxiosApiResponse<assistanceNewResponse>> => axiosInstance.post("/member/assistance/new", qs.stringify({
      type_id: assistanceTypeId,
      title,
      description
    }))
  }
}