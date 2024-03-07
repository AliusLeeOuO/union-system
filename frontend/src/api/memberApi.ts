import axiosInstance from "@/api/index"
import type { AxiosApiResponse } from "@/api/index"
import qs from "qs"

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

export interface activityDetailResponse {
  activity: activityListResponse
  isRegistered: boolean
}

// 会员援助列表
export interface assistanceListResponseData {
  total: number
  page_size: number
  page_num: number
  resolved_count: number
  pending_review_count: number
  assistances: assistanceListResponse[] | null
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
  username: string
}

export interface assistanceTypeResponse {
  assistance_type_id: number
  type_name: string
}

export interface assistanceNewResponse {
  request_id: number
}

export interface feeStandardResponse {
  standard_id: number
  amount: number
  category_id: number
}

export interface feeHistoryResponseData {
  total: number
  page_size: number
  page_num: number
  history: feeHistoryResponse[] | null
}

export interface feeHistoryResponse {
  bill_id: number
  user_id: number
  amount: number
  due_date: string
  fee_period: string
  fee_category: string
  payment_status: boolean
  created_at: string
}

export interface feeWaitingResponseData {
  bills: feeHistoryResponse[] | null
}

export interface notificationListResponse {
  page_num: number
  page_size: number
  total: number
  notifications: notificationResponseObject[] | null
}

export interface notificationResponseObject {
  content: string
  created_at: string
  notification_id: number
  read_status: boolean
  title: string
  sender_name: string
  sender_role: number
}

export interface activityTypeResponse {
  activity_type_id: number
  type_name: string
}

export default function useMemberApi() {
  return {
    activityList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<activityListResponseData>> =>
      axiosInstance.post(
        "/member/activity/list",
        qs.stringify({
          page_size: pageSize,
          page_num: pageNum
        })
      ),
    activityDetail: (activityId: number): Promise<AxiosApiResponse<activityDetailResponse>> =>
      axiosInstance.get(`/member/activity/detail/${activityId}`),
    activityRegister: (activityId: number): Promise<AxiosApiResponse<null>> =>
      axiosInstance.post(`/member/activity/register/${activityId}`),
    activityCancel: (activityId: number): Promise<AxiosApiResponse<null>> =>
      axiosInstance.delete(`/member/activity/cancel/${activityId}`),
    activityType: (): Promise<AxiosApiResponse<activityTypeResponse[]>> => axiosInstance.get("/member/activity/type"),
    activityMemberList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<activityListResponseData>> =>
      axiosInstance.post(
        "/member/activity/history",
        qs.stringify({
          page_size: pageSize,
          page_num: pageNum
        })
      ),
    assistanceList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<assistanceListResponseData>> =>
      axiosInstance.post(
        "/member/assistance/list",
        qs.stringify({
          page_size: pageSize,
          page_num: pageNum
        })
      ),
    assistanceDetail: (assistanceId: number): Promise<AxiosApiResponse<assistanceDetailResponse>> =>
      axiosInstance.post(
        `/member/assistance/view`,
        qs.stringify({
          request_id: assistanceId
        })
      ),
    assistanceReply: (requestId: number, responseText: string): Promise<AxiosApiResponse<null>> =>
      axiosInstance.post(
        "/member/assistance/reply",
        qs.stringify({
          request_id: requestId,
          response_text: responseText
        })
      ),
    assistanceClose: (requestId: number): Promise<AxiosApiResponse<null>> =>
      axiosInstance.post(
        "/member/assistance/close",
        qs.stringify({
          request_id: requestId
        })
      ),
    assistanceType: (): Promise<AxiosApiResponse<assistanceTypeResponse[]>> =>
      axiosInstance.get("/member/assistance/type"),
    assistanceNew: (
      assistanceTypeId: number,
      title: string,
      description: string
    ): Promise<AxiosApiResponse<assistanceNewResponse>> =>
      axiosInstance.post(
        "/member/assistance/new",
        qs.stringify({
          type_id: assistanceTypeId,
          title,
          description
        })
      ),
    feeStandard: (): Promise<AxiosApiResponse<feeStandardResponse>> =>
      axiosInstance.post("/member/fee/standard"),
    feeHistory: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<feeHistoryResponseData>> =>
      axiosInstance.post(
        "/member/fee/list",
        qs.stringify({
          page_size: pageSize,
          page_num: pageNum
        })
      ),
    waitingFeeList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<feeWaitingResponseData>> =>
      axiosInstance.post(
        "/member/fee/waiting",
        qs.stringify({
          page_size: pageSize,
          page_num: pageNum
        })
      ),
    notificationList: (
      pageSize: number,
      pageNum: number
    ): Promise<AxiosApiResponse<notificationListResponse>> =>
      axiosInstance.post(
        "/member/notification/list",
        qs.stringify({
          page_num: pageNum,
          page_size: pageSize
        })
      ),
    notificationRead: (notificationId: number): Promise<AxiosApiResponse<null>> => axiosInstance.post(`/member/notification/read/${notificationId}`),
    notificationReadAll: (): Promise<AxiosApiResponse<null>> => axiosInstance.post("/member/notification/readAll"),
    getNotificationUnreadCount: (): Promise<AxiosApiResponse<number>> => axiosInstance.get("/member/notification/unreadCount")
  }
}
