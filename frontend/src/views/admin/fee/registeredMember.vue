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
  </a-table>
</template>
<script setup lang="ts">
import dayjs from "dayjs"
import { onMounted, reactive } from "vue"
import useAdminApi, { type registeredFeeListItem } from "@/api/adminApi"
import { handleXhrResponse } from "@/api"
import { Message } from "@arco-design/web-vue"
const { getRegisteredFeeList } = useAdminApi()
const columns = [
  {
    title: "操作用户名",
    slotName: "username"
  },
  {
    title: "会费金额",
    dataIndex: "fee_amount"
  },
  {
    title: "注册会费时间",
    slotName: "regTime"
  }
]

const registeredFeeList = reactive<registeredFeeListItem[]>([])

const page = reactive({
  current: 1,
  pageSize: 10,
  total: 0
})

const fetchFeeList = async () => {
  const { data } = await handleXhrResponse(() => getRegisteredFeeList(page.current, page.pageSize), Message)
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
