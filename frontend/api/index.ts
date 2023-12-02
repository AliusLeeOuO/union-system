import axios from "axios"

const API_URL = process.env.API_URL || "/"

const axiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 10000
})

export default axiosInstance