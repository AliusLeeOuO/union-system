import { defineStore } from 'pinia'
import { ref } from 'vue'
import useMemberApi from '@/api/memberApi'

export const useNotificationStore = defineStore('notification', () => {
  const notificationCount = ref(0)
  const refreshNotificationCount = async () => {
    const { getNotificationUnreadCount } = useMemberApi()
    try {
      const { data } = await getNotificationUnreadCount()
      notificationCount.value = data.data
    }
    catch (error) {
      console.warn('Failed to get notification count', error)
    }
  }
  return {
    notificationCount,
    refreshNotificationCount
  }
})
