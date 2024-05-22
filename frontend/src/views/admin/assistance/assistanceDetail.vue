<template>
  <a-card class="mb-4" title="援助状态">
    <a-steps label-placement="vertical" :current="state.status.id" class="mb-4 mt-4">
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
  <a-card class="mb-4" title="帮助信息">
    <a-descriptions
      :data="descriptionData" size="large" layout="inline-vertical" :column="4"
      bordered
    />
  </a-card>
  <a-card class="mb-4" title="交流记录">
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
  <a-card v-if="state.status.id !== 4" class="mb-4" title="回复援助">
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
      <div class="submit-button flex justify-end flex-items-center">
        <span>新状态：</span>
        <a-select v-model="submitAssistanceForm.new_status" :style="{ width: '220px' }" placeholder="选择回复状态">
          <a-option :value="1">
            待审核
          </a-option>
          <a-option :value="2">
            处理中
          </a-option>
          <a-option :value="3">
            已解决
          </a-option>
          <a-option :value="4">
            已关闭
          </a-option>
        </a-select>
        <a-button type="primary" html-type="submit">
          提交回复
        </a-button>
      </div>
    </a-form>
  </a-card>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router'
import { Message, type ValidatedError } from '@arco-design/web-vue'
import { onMounted, reactive } from 'vue'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type assistanceDetailResponse } from '@/api/adminApi'

const adminApi = useAdminApi()
const route = useRoute()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault('Asia/Shanghai')

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
  const { data } = await handleXhrResponse(() => adminApi.assistanceDetail(assistantId), Message)
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
  response_text: '',
  new_status: 3
})

// 提交回复
async function handleSubmit(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    await handleXhrResponse(() => adminApi.assistanceReply(Number(route.params.id), submitAssistanceForm.response_text, submitAssistanceForm.new_status), Message)
    Message.success('回复成功')
    submitAssistanceForm.response_text = ''
    submitAssistanceForm.new_status = 3
    await getAssistanceDetail()
  }
}
</script>

<style scoped lang="less">
.description-title {
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
  gap: 5px;
  font-size: 1rem;
}
</style>
