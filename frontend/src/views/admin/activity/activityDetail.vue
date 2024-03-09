<template>
  <a-typography-title :heading="2">
    活动详情
  </a-typography-title>
  <div class="activity-detail-content">
    <div class="activity-detail-item">
      <div class="description-title">活动名称</div>
      <div class="activity-detail-item-content">{{ activityDetail.title }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">活动描述</div>
      <div class="activity-detail-item-content">{{ activityDetail.description }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">活动类型</div>
      <div class="activity-detail-item-content">{{ activityDetail.activityTypeName }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">报名人数</div>
      <div class="activity-detail-item-content activity-detail-flex">
        {{ activityDetail.registrationCount }}/{{ activityDetail.maxParticipants }}
        <a-progress :percent="activityDetail.registrationCount / activityDetail.maxParticipants" :show-text="false" />
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">活动地址</div>
      <div class="activity-detail-item-content">{{ activityDetail.location }}</div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">活动时间</div>
      <div class="activity-detail-item-content">
        {{ dayjs.tz(activityDetail.startTime).format("YYYY年MM月DD日 HH:mm") }}
        -
        {{ dayjs.tz(activityDetail.endTime).format("YYYY年MM月DD日 HH:mm") }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">报名用户</div>
      <div class="activity-detail-item-content">
        <a-list>
          <a-list-item v-for="item in regUserList">
            <div class="reg-user-block">
              <div class="user-id">
                <a-tag>{{ item.userId }}</a-tag>
              </div>
              <span>{{ item.userName }}</span>
              <span>{{ item.phone }}</span>
              <span>{{ item.email }}</span>
              <div>
                <a-popconfirm content="确定要取消报名吗？" @ok="cancelUserReg(item.userId)">
                  <a-button status="danger">取消报名</a-button>
                </a-popconfirm>
              </div>
            </div>
          </a-list-item>
        </a-list>
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">操作</div>
      <div class="activity-detail-item-content activity-detail-flex">
        <a-button status="warning" long>关闭活动</a-button>
        <a-button status="danger" long @click="visibleWarning = true">删除活动</a-button>
      </div>
    </div>
  </div>
  <a-modal v-model:visible="visibleWarning" title="危险！" simple class="drop-activity-modal" @before-ok="handleWarningDropActivity">
    <p>删除活动是不可逆的操作，请谨慎操作！</p>
    <a-form ref="dropActivityFormRef" :model="dropActivityForm" :label-col-props="{
        span: 6
      }" :wrapper-col-props="{
        span: 18
      }">
      <a-form-item field="password" label="您的密码" :rules="[{required:true,message:'请输入密码'}]" validate-trigger="blur">
        <a-input-password v-model="dropActivityForm.password" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>
<script setup lang="ts">
import dayjs from "dayjs"
import { reactive, onMounted, ref } from "vue"
import { type FormInstance, Message, Modal, type ValidatedError } from "@arco-design/web-vue"
import { handleXhrResponse } from "@/api"
import { useRoute, useRouter } from "vue-router"
import utc from "dayjs/plugin/utc"
import timezone from "dayjs/plugin/timezone"
import useAdminApi, { type activityRegistrations } from "@/api/adminApi"

dayjs.extend(timezone)
dayjs.extend(utc)

dayjs.tz.setDefault("Asia/Shanghai")


const adminApi = useAdminApi()
const route = useRoute()
const router = useRouter()


const activityDetail = reactive({
  title: "",
  description: "",
  registrationCount: 0,
  maxParticipants: 0,
  location: "",
  startTime: "1970-01-01T08:00:00+08:00",
  endTime: "1970-01-01T08:00:00+08:00",
  activityTypeName: ""
})

const activityId = Number(route.params.id)

const regUserList = reactive<activityRegistrations[]>([])


const getActivityDetail = async (activityId: number) => {
  const { data } = await handleXhrResponse(() => adminApi.activityDetail(activityId), Message)
  activityDetail.title = data.data.activity.title
  activityDetail.description = data.data.activity.description
  activityDetail.registrationCount = data.data.activity.registrationCount
  activityDetail.maxParticipants = data.data.activity.maxParticipants
  activityDetail.location = data.data.activity.location
  activityDetail.startTime = data.data.activity.startTime
  activityDetail.endTime = data.data.activity.endTime
  activityDetail.activityTypeName = data.data.activity.activityTypeName
  if (data.data.registrations !== null) {
    regUserList.splice(0, regUserList.length, ...data.data.registrations)
  }
}

const cancelUserReg = async (userId: number) => {
  await handleXhrResponse(() => adminApi.cancelUserReg(activityId, userId), Message)
  Message.success("取消报名成功")
  await getActivityDetail(activityId)
}

const visibleWarning = ref(false)
const dropActivityForm = reactive({
  password: ""
})

const dropActivityFormRef = ref<FormInstance | null>(null)

const handleWarningDropActivity = async (done: (closed: boolean) => void) => {
  if (dropActivityFormRef && dropActivityFormRef.value && !await dropActivityFormRef.value.validate()) {
    await handleXhrResponse(() => adminApi.dropActivity(activityId, dropActivityForm.password), Message)
    Message.success("删除活动成功")
    done(true)
    await router.replace("/admin/manageActivity")
    return
  }
  done(false)
}

onMounted(async () => {
  const activityId = Number(route.params.id)
  await getActivityDetail(activityId)
})
</script>
<style scoped lang="less">
.activity-detail-content {
  padding: 10px;

  .activity-detail-item {
    padding-bottom: 10px;

    &:not(:last-child) {
      border-bottom: 1px solid #f0f0f0;
    }
  }
}

.description-title {
  margin-top: 10px;
  font-size: 16px;
  padding-bottom: 10px;

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

.activity-detail-item-content {
  line-height: 28px;

  .reg-user-block {
    display: grid;
    grid-template-columns: 50px 1fr 1fr 1fr auto;
    gap: 5px;
    align-items: center;

    .user-id {
      display: flex;
      justify-content: flex-start;
      align-items: center;
    }
  }
}

.activity-detail-flex {
  display: flex;
  gap: 10px;
}

.drop-activity-modal {
  p {
    text-align: center;
    margin-bottom: 10px;
  }
}
</style>