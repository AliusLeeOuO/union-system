import type { AxiosApiResponse } from "@/api/index"
import axiosInstance from "@/api/index"
import qs from "qs"

interface getCaptchaResponseData {
  captchaID: string;
  imagePath: string;
}

interface loginResponseData {
  role: number
  status: boolean
  token: string
  user_id: number
  username: string
}

interface getUserInfoResponseData {
  role: number
  status: number
  userID: number
  username: string
}


export default function useUserApi() {
  return {
    getCaptcha: (): Promise<AxiosApiResponse<getCaptchaResponseData>> => axiosInstance.get("/user/getCaptcha"),
    login: (
      username: string,
      password: string,
      captchaId: string,
      captchaVal: string
    ): Promise<AxiosApiResponse<loginResponseData>> => axiosInstance.post("/user/login", qs.stringify({
      username,
      password,
      captcha_id: captchaId,
      captcha_val: captchaVal
    })),
    getUserInfo: (): Promise<AxiosApiResponse<getUserInfoResponseData>> => axiosInstance.get("/user/getUserInfo"),
    logout: (): Promise<AxiosApiResponse<null>> => axiosInstance.post("/user/logout")
  }
}
