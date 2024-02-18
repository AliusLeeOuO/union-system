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
  isActive: boolean
  registrationCount: number
}

export default function useMemberApi() {
  return {
    activityList: (pageSize: number, pageNum: number): Promise<AxiosApiResponse<activityListResponseData>> => axiosInstance.post("/member/activity/list", qs.stringify({
      page_size: pageSize,
      page_num: pageNum
    }))
  }
}