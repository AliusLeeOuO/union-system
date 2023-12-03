import type { AxiosApiResponse } from "~/api/index"
import axiosInstance from "~/api/index"
import qs from "qs"

interface getCaptchaResponseData {
  captchaID: string;
  imagePath: string;
}

interface loginResponseData {
  role: number
  status: number
  token: string
  userId: number
  username: string
}

interface getUserInfoResponseData {
  role: number
  status: number
  userId: number
  username: string
}

export default function() {
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
  }
}
