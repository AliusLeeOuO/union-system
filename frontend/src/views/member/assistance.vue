<template>
  <div>
    <h1>帮助</h1>
  </div>
  <a-tabs default-active-key="1">
    <a-tab-pane key="1" title="我的请求">
      <div class="my-assistant-overview">
        <div class="my-assistant-overview-block">
          <a-statistic title="总工单数" :value="overviewItem.total" :value-from="0" animation />
        </div>
        <div class="my-assistant-overview-block">
          <a-statistic title="待我处理" :value="overviewItem.resolved" :value-from="0" animation />
        </div>
        <div class="my-assistant-overview-block">
          <a-statistic title="处理中" :value="overviewItem.pending" :value-from="0" animation />
        </div>
      </div>
      <a-table :columns="columns" :data="tableData" size="large" @page-change="changePage" :pagination="{
        total: overviewItem.total,
        pageSize: 10
      }">
        <template #status="{ record }">
          <a-tag color="cyan" v-if="record.status_id === 1">待审核</a-tag>
          <a-tag color="blue" v-else-if="record.status_id === 2">处理中</a-tag>
          <a-tag color="green" v-else-if="record.status_id === 3">已解决</a-tag>
          <a-tag color="gray" v-else-if="record.status_id === 4">已关闭</a-tag>
        </template>
        <template #action="{ record }">
          <router-link :to="`/member/assistanceDetail/${record.assistance_id}`">
            <a-button>查看</a-button>
          </router-link>
        </template>
      </a-table>
    </a-tab-pane>
    <a-tab-pane key="2" title="新建请求">
      <a-form :model="newFormItem" @submit="submitRequest" :label-col-props="{
        span: 2
      }" :wrapper-col-props="{
        span: 22
      }">
        <a-form-item field="type_id" label="请求类型" required>
          <a-radio-group v-model="newFormItem.type_id" type="button">
            <a-radio :value="item.assistance_type_id" v-for="item in assistanceType" :key="item.assistance_type_id">
              {{ item.type_name }}
            </a-radio>
          </a-radio-group>
        </a-form-item>
        <a-form-item field="title" label="请求标题"
                     :rules="[{required:true,message:'请输入标题'},{minLength:5,message:'最少需要5个字符'}]"
                     :validate-trigger="['change','input']"
        >
          <a-input v-model="newFormItem.title" placeholder="输入请求标题" />
        </a-form-item>
        <a-form-item label="详细信息"
                     validate-trigger="input"
                     :rules="[{required:true,message:'请输入详细信息'}]"
                     field="description"
        >
          <a-textarea
            placeholder="在这里输入详细信息"
            :auto-size="{
              minRows: 3
            }"
            v-model="newFormItem.description"
          />
        </a-form-item>
        <div>
          <a-button type="primary" long size="large" html-type="submit">提交</a-button>
        </div>
      </a-form>
    </a-tab-pane>
  </a-tabs>
</template>
<script setup lang="ts">
import { reactive, onMounted } from "vue"
import useMemberApi from "@/api/memberApi"
import type { assistanceListResponse, assistanceTypeResponse } from "@/api/memberApi"
import { Message, type ValidatedError } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import dayjs from "dayjs"
import { useRouter } from "vue-router"

const router = useRouter()
const memberApi = useMemberApi()

const pageItem = reactive({
  pageSize: 10,
  current: 1
})

const getMyRequest = async () => {
  const { data } = await handleXhrResponse(() => memberApi.assistanceList(pageItem.pageSize, pageItem.current), Message)
  // 清除原有数据
  tableData.splice(0, tableData.length)
  overviewItem.total = data.data.total
  overviewItem.pending = data.data.pending_review_count
  overviewItem.resolved = data.data.resolved_count
  if (data.data.assistances === null) {
    return
  }
  data.data.assistances.forEach((item: assistanceListResponse) => {
    tableData.push({
      title: item.title,
      assistance_id: item.assistance_id,
      assistance_type: item.assistance_type,
      assistance_type_id: item.assistance_type_id,
      description: item.description,
      request_date: dayjs(item.request_date).format("YYYY-MM-DD HH:mm:ss"),
      status: item.status,
      status_id: item.status_id
    })
  })
}

const overviewItem = reactive({
  total: 0,
  pending: 0,
  resolved: 0
})

const columns = [
  {
    title: "请求编号",
    dataIndex: "assistance_id"
  },
  {
    title: "标题",
    dataIndex: "title"
  },
  {
    title: "类型",
    dataIndex: "assistance_type"
  },
  {
    title: "状态",
    slotName: "status"
  },
  {
    title: "提交时间",
    dataIndex: "request_date"
  },
  {
    title: "操作",
    slotName: "action"
  }
]
const tableData = reactive<assistanceListResponse[]>([])

const changePage = async (page: number) => {
  pageItem.current = page
  await getMyRequest()
}

// 新建请求
const newFormItem = reactive({
  title: "",
  type_id: 0,
  description: ""
})

const assistanceType = reactive<assistanceTypeResponse[]>([])
const getAssistanceType = async () => {
  const { data } = await handleXhrResponse(() => memberApi.assistanceType(), Message)
  assistanceType.splice(0, assistanceType.length)
  assistanceType.push(...data.data)
}

const submitRequest = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    const { data } = await handleXhrResponse(() => memberApi.assistanceNew(newFormItem.type_id, newFormItem.title, newFormItem.description), Message)
    Message.success("提交成功")
    await router.push(`/member/assistanceDetail/${data.data.request_id}`)
  }
}


onMounted(async () => {
  await getMyRequest()
  await getAssistanceType()
})

</script>
<style scoped lang="less">
.my-assistant-overview {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 5px;
  padding: 20px;

  .my-assistant-overview-block {
    text-align: center;

    .my-assistant-overview-title {
      font-size: 12px;
    }

    .my-assistant-overview-content {
      font-size: 20px;
      margin-top: 10px;
    }
  }
}
</style>