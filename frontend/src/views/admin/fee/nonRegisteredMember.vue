<template>
  <a-table
    :columns="columns"
    :data="registeredFeeList"
    size="large"
    @page-change="changePage"
    :pagination="{
      total: page.total,
      pageSize: page.pageSize,
      current: page.current
    }"
  >
    <template #username="{ record }">
      <a-popover>
        <div>
          {{ record.username }}
        </div>
        <template #content>
          <p>用户ID：{{ record.user_id }}</p>
        </template>
      </a-popover>
    </template>
    <template #regTime="{ record }">
      {{ dayjs.tz(record.registration_date).format("YYYY-MM-DD HH:mm:ss") }}
    </template>
    <template #action="{ record }">
      <a-button>注册会员费率</a-button>
    </template>
  </a-table>
</template>
<script setup lang="ts">
import dayjs from "dayjs"
import { onMounted, reactive } from "vue"
import useAdminApi, { type nonRegisteredFeeListItem } from "@/api/adminApi"
import { handleXhrResponse } from "@/api"
import { Message } from "@arco-design/web-vue"
const { getNonRegisteredFeeList } = useAdminApi()
const columns = [
  {
    title: "用户名",
    slotName: "username"
  },
  {
    title: "操作",
    slotName: "action"
  }
]

const registeredFeeList = reactive<nonRegisteredFeeListItem[]>([])

const page = reactive({
  current: 1,
  pageSize: 10,
  total: 0
})

const fetchFeeList = async () => {
  const { data } = await handleXhrResponse(() => getNonRegisteredFeeList(page.current, page.pageSize), Message)
  page.total = data.data.total
  if (data.data.users !== null) {
    registeredFeeList.splice(0, registeredFeeList.length, ...data.data.users)
  }
}

const changePage = async (newPage: number) => {
  page.current = newPage
  await fetchFeeList()
}


onMounted(() => {
  fetchFeeList()
})
</script>
<style scoped lang="less">

</style>
