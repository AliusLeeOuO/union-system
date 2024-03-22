<template>
  <a-typography-title :heading="2">
    添加新活动
  </a-typography-title>
  <a-form
    :model="formItem"
    :rules="rules"
    @submit="handleSubmit"
    layout="vertical"
  >
    <a-form-item field="title" label="活动名称">
      <a-input v-model="formItem.title" />
    </a-form-item>
    <a-form-item field="description" label="活动详情">
      <a-textarea v-model="formItem.description" />
    </a-form-item>
    <a-form-item field="type" label="活动类型">
      <a-radio-group v-model="formItem.type" type="button">
        <a-radio v-for="item in activityTypeList" :key="item.activity_type_id" :value="item.activity_type_id">
          {{ item.type_name }}
        </a-radio>
      </a-radio-group>
    </a-form-item>
    <a-form-item field="maxCount" label="最大报名人数">
      <a-input-number v-model="formItem.maxCount" />
    </a-form-item>
    <a-form-item field="adderss" label="活动地址">
      <a-input v-model="formItem.adderss" />
    </a-form-item>
    <a-form-item field="time" label="活动时间">
      <a-range-picker
        show-time
        :time-picker-props="{ defaultValue: ['00:00:00', '09:09:06'] }"
        format="YYYY-MM-DD HH:mm"
        v-model:model-value="formItem.time"
      />
    </a-form-item>
    <a-form-item field="active" label="是否激活">
      <a-switch v-model="formItem.active" />
    </a-form-item>
    <div>
      <a-button type="primary" html-type="submit" size="large" long>添加</a-button>
    </div>
  </a-form>
</template>
<script setup lang="ts">
import { onMounted, reactive } from "vue"
import { type FieldRule, Message, type ValidatedError } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import useAdminApi, { type activityType } from "@/api/adminApi"
import { useRouter } from "vue-router"
import dayjs from "dayjs"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"

const router = useRouter()

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.tz.setDefault("Asia/Shanghai")

const adminApi = useAdminApi()


const formItem = reactive({
  title: "",
  description: "",
  type: -1,
  maxCount: 0,
  adderss: "",
  time: [
    "",
    ""
  ],
  active: true
})

const rules: Record<string, FieldRule | FieldRule[]> = {
  title: [{ required: true, message: "请输入标题" }],
  description: [{ required: true, message: "请输入活动详情" }],
  type: [
    {
      required: true, message: "请选择活动类型",
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value === -1) {
            callback("请选择活动类型")
          }
          resolve(void 0)
        })
      }
    }
  ],
  maxCount: [
    {
      required: true,
      message: "请输入最大报名人数",
      validator: (value, callback) => {
        return new Promise((resolve) => {
          if (value <= 0) {
            callback("最大报名人数必须大于0")
          }
          resolve(void 0)
        })
      }
    }
  ],
  adderss: [{ required: true, message: "请输入活动地址" }],
  time: [{
    required: true,
    message: "请选择活动时间",
    validator: (value, callback) => {
      return new Promise((resolve) => {
        // 如果是默认值，提示输入
        if (value[0] === "" || value[1] === "") {
          callback("请选择活动时间")
        }
        resolve(void 0)
      })
    }
  }],
  active: [{ required: true, message: "请选择是否激活" }]
}

const handleSubmit = async (form: {
  values: Record<string, any>;
  errors: Record<string, ValidatedError> | undefined
}) => {
  if (!form.errors) {
    const startTime = dayjs.tz(formItem.time[0]).format("YYYY-MM-DDTHH:mm:ssZ")
    const endTime = dayjs.tz(formItem.time[1]).format("YYYY-MM-DDTHH:mm:ssZ")
    const { data } = await handleXhrResponse(() => adminApi.addNewActivity(
      formItem.title,
      formItem.description,
      startTime,
      endTime,
      formItem.adderss,
      formItem.type,
      formItem.maxCount,
      formItem.active
    ), Message)
    Message.success("新建活动成功")
    await router.push(`/admin/manageActivityDetail/${data.data.id}`)
  }
}

const activityTypeList = reactive<activityType[]>([])
const fetchActivityType = async () => {
  const { data } = await handleXhrResponse(() => adminApi.getActivityTypes(), Message)
  activityTypeList.splice(0, activityTypeList.length, ...data.data)
}

onMounted(async () => {
  await fetchActivityType()
})

</script>
<style scoped lang="less">

</style>