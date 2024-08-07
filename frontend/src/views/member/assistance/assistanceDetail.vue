<template>
  <a-card title="援助状态" class="mb-4">
    <template #extra>
      <a-button v-if="state.status.id !== 4" @click="closeModal = true">
        关闭本援助
      </a-button>
    </template>
    <a-steps label-placement="vertical" :current="state.status.id" class="step-items">
      <a-step>
        待审核
      </a-step>
      <a-step>
        处理中
      </a-step>
      <a-step>
        已解决
      </a-step>
      <a-step>
        已关闭
      </a-step>
    </a-steps>
  </a-card>
  <a-card title="帮助信息" class="mb-4">
    <a-descriptions
      :data="descriptionData" size="large" layout="inline-vertical" :column="4"
      bordered
    />
  </a-card>
  <a-card title="交流记录" class="mb-4">
    <a-empty v-if="state.responses.length === 0" />
    <a-comment
      v-for="response in state.responses"
      v-else
      :key="response.response_id"
      :author="response.username"
      :content="response.response_text"
      :datetime="dayjs.tz(response.created_at).format('YYYY-MM-DD HH:mm:ss')"
    />
  </a-card>
  <a-card v-if="state.status.id !== 4" title="补充反馈">
    <a-form :model="submitAssistanceForm" @submit="handleSubmit">
      <a-form-item
        hide-label
        validate-trigger="blur"
        :rules="[{ required: true, message: '请输入回复内容' }]"
        field="response_text"
      >
        <a-textarea
          v-model="submitAssistanceForm.response_text"
          placeholder="在这里输入你的回复"
          auto-size
        />
      </a-form-item>
      <div class="submit-button">
        <a-button type="primary" html-type="submit">
          提交回复
        </a-button>
      </div>
    </a-form>
  </a-card>
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
import { useRoute } from 'vue-router'
import { Message, type ValidatedError } from '@arco-design/web-vue'
import { onMounted, reactive, ref } from 'vue'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useMemberApi, { type assistanceDetailResponse } from '@/api/memberApi'

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')
const memberApi = useMemberApi()
const route = useRoute()

const state = reactive<assistanceDetailResponse>({
  created_at: '',
  updated_at: '',
  assistance_type: '',
  description: '',
  id: 0,
  responses: [],
  status: { id: 0, name: '' },
  title: '',
  type: { assistance_type_id: 0, type_name: '' }
})

const descriptionData = reactive([{
  label: '帮助标题',
  value: ''
}, {
  label: '帮助类型',
  value: ''
}, {
  label: '创建时间',
  value: ''
}, {
  label: '更新时间',
  value: ''
}, {
  label: '详细描述',
  value: ''
}])

async function getAssistanceDetail() {
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
  descriptionData[2].value = dayjs.tz(data.data.created_at).format('YYYY-MM-DD HH:mm:ss')
  descriptionData[3].value = dayjs.tz(data.data.updated_at).format('YYYY-MM-DD HH:mm:ss')
  descriptionData[4].value = data.data.description
}

onMounted(async () => {
  await getAssistanceDetail()
})

const submitAssistanceForm = reactive({
  response_text: ''
})

// 提交回复
async function handleSubmit(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    try {
      await handleXhrResponse(() => memberApi.assistanceReply(Number(route.params.id), form.values.response_text), Message)
      Message.success('回复成功')
      submitAssistanceForm.response_text = ''
      await getAssistanceDetail()
    }
    catch (error) {
      console.log(error)
    }
  }
}

// 关闭援助
const closeModal = ref(false)
async function closeAssistance() {
  try {
    await handleXhrResponse(() => memberApi.assistanceClose(Number(route.params.id)), Message)
    Message.success('关闭成功')
    await getAssistanceDetail()
  }
  catch (error) {
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
