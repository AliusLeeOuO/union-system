<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{route, paths}">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <div class="assistance-status">
    <div class="description-title">援助状态</div>
    <a-button @click="closeModal = true" v-if="state.status.id !== 4">关闭本援助</a-button>
  </div>
  <a-steps label-placement="vertical" :current="state.status.id" class="step-items">
    <a-step description="This is a description">待审核</a-step>
    <a-step description="This is a description">处理中</a-step>
    <a-step description="This is a description">已解决</a-step>
    <a-step description="This is a description">已关闭</a-step>
  </a-steps>
  <div>
    <a-descriptions :data="descriptionData" size="large" title="帮助信息" layout="inline-vertical" :column="4"
                    bordered />
    <div>
      <div class="description-title">交流记录</div>
      <div>
        <a-empty v-if="state.responses.length === 0" />
        <a-comment v-for="response in state.responses"
                   :author="response.username"
                   :key="response.response_id"
                   :content="response.response_text"
                   :datetime="dayjs.tz(response.created_at).format('YYYY-MM-DD HH:mm:ss')"
                   v-else
        />
      </div>
      <div v-if="state.status.id !== 4">
        <div class="description-title">补充反馈</div>
        <a-form :model="submitAssistanceForm" @submit="handleSubmit">
          <a-form-item hide-label
                       validate-trigger="blur"
                       :rules="[{required:true,message:'请输入回复内容'}]"
                       field="response_text"
          >
            <a-textarea
              placeholder="在这里输入你的回复"
              auto-size
              v-model="submitAssistanceForm.response_text"
            />
          </a-form-item>
          <div class="submit-button">
            <a-button type="primary" html-type="submit">提交回复</a-button>
          </div>
        </a-form>
      </div>
    </div>
  </div>
  <a-modal v-model:visible="closeModal" @ok="closeAssistance">
    <template #title>
      关闭援助
    </template>
    <div>
      确定关闭本援助吗？关闭后将无法再次开启。
    </div>
  </a-modal>
</template>
<script setup lang="ts">
import { useRoute } from "vue-router"
import useMemberApi, { type assistanceDetailResponse } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { type BreadcrumbRoute, Message, type ValidatedError } from "@arco-design/web-vue"
import { onMounted, reactive, ref } from "vue"
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")
const memberApi = useMemberApi()
const route = useRoute()

// 面包屑
const routes: BreadcrumbRoute[] = [
  {
    path: "/member/assistance",
    label: "帮助"
  },
  {
    path: route.path,
    label: "查看详情"
  }
]


const getAssistanceDetail = async () => {
  const assistantId = Number(route.params.id)
  const { data } = await handleXhrResponse(() => memberApi.assistanceDetail(assistantId), Message)
  state.assistance_type = data.data.assistance_type
  state.description = data.data.description
  state.id = data.data.id
  state.responses = data.data.responses
  state.status = data.data.status
  state.title = data.data.title
  state.type = data.data.type
  // 实验性
  descriptionData[0].value = data.data.title
  descriptionData[1].value = data.data.type.type_name
  descriptionData[2].value = dayjs.tz(data.data.created_at).format("YYYY-MM-DD HH:mm:ss")
  descriptionData[3].value = dayjs.tz(data.data.updated_at).format("YYYY-MM-DD HH:mm:ss")
  descriptionData[4].value = data.data.description
}

const state = reactive<assistanceDetailResponse>({
  created_at: "", updated_at: "",
  assistance_type: "",
  description: "",
  id: 0,
  responses: [],
  status: { id: 0, name: "" },
  title: "",
  type: { assistance_type_id: 0, type_name: "" }
})

const descriptionData = reactive([{
  label: "帮助标题",
  value: ""
}, {
  label: "帮助类型",
  value: ""
}, {
  label: "创建时间",
  value: ""
}, {
  label: "更新时间",
  value: ""
}, {
  label: "详细描述",
  value: ""
}])


onMounted(async () => {
  await getAssistanceDetail()
})

// 提交回复
const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    try {
      await handleXhrResponse(() => memberApi.assistanceReply(Number(route.params.id), form.values.response_text), Message)
      Message.success("回复成功")
      submitAssistanceForm.response_text = ""
      await getAssistanceDetail()
    } catch (error) {
      console.log(error)
    }
  }
}

const submitAssistanceForm = reactive({
  response_text: ""
})


// 关闭援助
const closeModal = ref(false)
const closeAssistance = async () => {
  try {
    await handleXhrResponse(() => memberApi.assistanceClose(Number(route.params.id)), Message)
    Message.success("关闭成功")
    await getAssistanceDetail()
  } catch (error) {
    console.log(error)
  }
}

</script>
<style scoped lang="less">
.assistance-status {
  display: flex;
  justify-content: space-between;
}


.step-items {
  margin: 20px 0;
}

.description-title {
  margin-top: 10px;
  font-size: 16px;
  padding-bottom: 5px;

  &::before {
    content: "";
    display: inline-block;
    width: 8px; /* 方块的宽度 */
    height: 18px; /* 方块的高度 */
    background-color: rgb(var(--primary-6)); /* 方块的颜色 */
    margin-right: 8px; /* 和文本之间的距离 */
    vertical-align: middle;
  }
}

.submit-textarea {
  padding: 5px 0;
}

.submit-button {
  display: flex;
  justify-content: flex-end;
}
</style>