<template>
  <h1>
    帮助
  </h1>
  <a-steps label-placement="vertical" :current="state.status.id">
    <a-step description="This is a description">待审核</a-step>
    <a-step description="This is a description">处理中</a-step>
    <a-step description="This is a description">已解决</a-step>
    <a-step description="This is a description">已关闭</a-step>
  </a-steps>
  <div>
    <a-descriptions :data="descriptionData" size="large" title="帮助信息" layout="inline-vertical" :column="4"
                    bordered />
    <div>交流记录</div>
    <!--  TODO: 这里后端要传回复者的用户名   -->
    <a-comment v-for="response in state.responses" :author="`response.responder_id`" :key="response.response_id"
               :content="response.response_text"
               :datetime="dayjs(response.created_at).format('YYYY-MM-DD HH:mm:ss')" />
    <a-textarea placeholder="在这里输入你的回复" auto-size />
    <a-button type="primary">提交回复</a-button>
  </div>
</template>
<script setup lang="ts">
import { useRoute } from "vue-router"
import useMemberApi, { type assistanceDetailResponse } from "@/api/memberApi"
import { handleXhrResponse } from "@/api"
import { Message } from "@arco-design/web-vue"
import { onMounted, reactive } from "vue"
import dayjs from "dayjs"

const memberApi = useMemberApi()
const route = useRoute()


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
  descriptionData[2].value = dayjs(data.data.created_at).format("YYYY-MM-DD HH:mm:ss")
  descriptionData[3].value = dayjs(data.data.updated_at).format("YYYY-MM-DD HH:mm:ss")
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


</script>
<style scoped lang="less">

</style>