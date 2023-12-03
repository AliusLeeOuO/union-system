import axios, { type AxiosResponse } from "axios"
import appConfig from "~/app.config"
//
// const API_URL = runtimeConfig.public.API_URL as string || "/"



let API_URL: string = process.env.NODE_ENV === "production" ? appConfig.api.API_URL_PROD : appConfig.api.API_URL_LOCAL

const axiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 10000
})
export default axiosInstance

export interface AxiosApiResponse<T> extends AxiosResponse {
  data: ApiResponse<T>;
}

interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}


