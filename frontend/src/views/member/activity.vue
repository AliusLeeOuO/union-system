<template>
  <div>
    <h1>会员活动</h1>
  </div>
  <a-tabs default-active-key="1">
    <a-tab-pane key="1" title="活动列表">
      <div class="activity-content">
        <div class="activity-items">
          <router-link :to="`/member/activityDetail/${item.activityId}`" class="activity-item" v-for="item in activityList" :key="item.activityId">
            <div class="activity-item-title">{{ item.title }}</div>
            <div class="activity-item-description">{{ item.description }}</div>
            <div class="activity-item-persons">报名人数：{{ item.registrationCount }}/{{ item.maxParticipants }}</div>
            <div class="activity-item-location">
              地址：{{ item.location }}
              活动类型：{{ item.activityTypeName }}
            </div>
            <div class="activity-item-time">{{ dayjs(item.startTime).format("YYYY年MM月DD日 HH:mm") }} -
              {{ dayjs(item.endTime).format("YYYY年MM月DD日 HH:mm") }}
            </div>
          </router-link>
        </div>
        <div class="activity-pagination">
          <a-pagination
            :total="pagination.total"
            v-model:page-size="pagination.pageSize"
            v-model:current="pagination.current"
            :default-page-size="5"
            show-page-size @change="pageChange"
            @page-size-change="pageSizeChange"
          />
        </div>
      </div>
    </a-tab-pane>
    <a-tab-pane key="2" title="我的活动">
      Content of Tab Panel 2
    </a-tab-pane>
  </a-tabs>
</template>
<script setup lang="ts">
import { onMounted, reactive } from "vue"
import useMemberApi from "@/api/memberApi"
import type { activityListResponseData } from "@/api/memberApi"
import { Message } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import dayjs from "dayjs"

const memberApi = useMemberApi()

const activityList = reactive<activityListResponseData["data"]>([])
const pagination = reactive({
  total: 0,
  pageSize: 5,
  current: 1
})

const pageSizeChange = async (pageSize: number) => {
  pagination.pageSize = pageSize
  pagination.current = 1
  await getActivityList()
}

const pageChange = async (current: number) => {
  pagination.current = current
  await getActivityList()
}

const getActivityList = async () => {
  const { data } = await handleXhrResponse(() => memberApi.activityList(pagination.pageSize, pagination.current), Message)
  // 清除原有数据
  activityList.splice(0, activityList.length)
  activityList.push(...data.data.data)
  pagination.total = data.data.total
}

onMounted(async () => {
  await getActivityList()
})
</script>
<style scoped lang="less">
.activity-content {
  // 改成圆角
  .activity-item {
    display: block;
    color: inherit;
    text-decoration: none;
    border-radius: 10px;
    background-color: #f5f5f5;
    padding: 20px;
    margin-top: 20px;
    margin-bottom: 20px;
    cursor: pointer;
    // dark mode
    @media (prefers-color-scheme: dark) {
      background-color: #232324;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .activity-item-title {
      font-size: 20px;
      font-weight: bold;
    }

    .activity-item-description {
      margin-top: 10px;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
    }

    .activity-item-content {
      margin-top: 10px;
    }

    .activity-item-time {
      margin-top: 10px;
    }

    .activity-item-persons {
      margin-top: 10px;
    }

    .activity-item-location {
      margin-top: 10px;
    }
  }

  .activity-pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
  }
}
</style>