<template>
  <div>
    <a-breadcrumb :routes="routes">
      <template #item-render="{ route }">
        <router-link :to="route">
          {{ route.label }}
        </router-link>
      </template>
    </a-breadcrumb>
  </div>
  <a-typography-title :heading="2">
    活动详情
  </a-typography-title>
  <div class="activity-detail-content">
    <div class="activity-detail-item">
      <div class="description-title">
        <span>活动名称</span>
        <a-button v-if="!changeActivityTitle" @click="changeActivityTitleCallback">
          修改
        </a-button>
        <a-button v-else @click="changeActivityTitle = false">
          取消
        </a-button>
      </div>
      <div v-if="!changeActivityTitle" class="activity-detail-item-content">
        {{ activityDetail.title }}
      </div>
      <div v-else class="activity-detail-item-content">
        <a-form
          :model="changeActivityTitleForm" :label-col-props="{
            span: 2,
          }" :wrapper-col-props="{
            span: 22,
          }" @submit="submitChangeActivityTitle"
        >
          <a-form-item field="title" label="活动名称" :rules="[{ required: true, message: '请输入活动名称' }]">
            <a-textarea v-model="changeActivityTitleForm.title" placeholder="输入新活动名称" auto-size allow-clear />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" html-type="submit">
              确认修改
            </a-button>
          </a-form-item>
        </a-form>
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>活动描述</span>
        <a-button v-if="!changeActivityDescription" @click="changeActivityDescriptionCallback">
          修改
        </a-button>
        <a-button v-else @click="changeActivityDescription = false">
          取消
        </a-button>
      </div>
      <div v-if="!changeActivityDescription" class="activity-detail-item-content">
        {{ activityDetail.description }}
      </div>
      <div v-else class="activity-detail-item-content">
        <a-form
          :model="changeActivityDescriptionForm" :label-col-props="{
            span: 2,
          }" :wrapper-col-props="{
            span: 22,
          }" @submit="submitChangeActivityDescription"
        >
          <a-form-item field="description" label="活动描述" :rules="[{ required: true, message: '请输入活动描述' }]">
            <a-textarea
              v-model="changeActivityDescriptionForm.description" placeholder="输入新活动描述" auto-size
              allow-clear
            />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" html-type="submit">
              确认修改
            </a-button>
          </a-form-item>
        </a-form>
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>活动类型</span>
        <a-button disabled>
          修改
        </a-button>
      </div>
      <div class="activity-detail-item-content">
        {{ activityDetail.activityTypeName }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>报名人数</span>
        <a-button disabled>
          修改
        </a-button>
      </div>
      <div class="activity-detail-item-content activity-detail-flex">
        {{ activityDetail.registrationCount }}/{{ activityDetail.maxParticipants }}
        <a-progress :percent="activityDetail.registrationCount / activityDetail.maxParticipants" :show-text="false" />
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>活动地址</span>
        <a-button v-if="!changeActivityLocation" @click="changeActivityLocationCallback">
          修改
        </a-button>
        <a-button v-else @click="changeActivityLocation = false">
          取消
        </a-button>
      </div>
      <div v-if="!changeActivityLocation" class="activity-detail-item-content">
        {{ activityDetail.location }}
      </div>
      <div v-else class="activity-detail-item-content">
        <a-form
          :model="changeActivityLocationForm" :label-col-props="{
            span: 2,
          }" :wrapper-col-props="{
            span: 22,
          }" @submit="submitChangeActivityLocation"
        >
          <a-form-item field="location" label="活动地址" :rules="[{ required: true, message: '请输入活动地址' }]">
            <a-input v-model="changeActivityLocationForm.location" placeholder="输入新活动地址" allow-clear />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" html-type="submit">
              确认修改
            </a-button>
          </a-form-item>
        </a-form>
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>活动时间</span>
        <a-button disabled>
          修改
        </a-button>
      </div>
      <div class="activity-detail-item-content">
        {{ dayjs.tz(activityDetail.startTime).format('YYYY年MM月DD日 HH:mm') }}
        -
        {{ dayjs.tz(activityDetail.endTime).format('YYYY年MM月DD日 HH:mm') }}
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        <span>报名用户</span>
        <a-button>导出报名用户</a-button>
      </div>
      <div class="activity-detail-item-content">
        <a-list>
          <a-list-item v-for="item in regUserList" :key="item.userId">
            <div class="reg-user-block">
              <div class="user-id">
                <a-tag>{{ item.userId }}</a-tag>
              </div>
              <span>{{ item.userName }}</span>
              <span>{{ item.phone }}</span>
              <span>{{ item.email }}</span>
              <div>
                <a-popconfirm content="确定要取消报名吗？" @ok="cancelUserReg(item.userId)">
                  <a-button status="danger">
                    取消报名
                  </a-button>
                </a-popconfirm>
              </div>
            </div>
          </a-list-item>
        </a-list>
      </div>
    </div>
    <div class="activity-detail-item">
      <div class="description-title">
        操作
      </div>
      <div class="activity-detail-item-content activity-detail-flex">
        <a-button status="warning" disabled long>
          关闭活动
        </a-button>
        <a-button status="danger" long @click="visibleWarning = true">
          删除活动
        </a-button>
      </div>
    </div>
  </div>
  <a-modal
    v-model:visible="visibleWarning" title="危险！" simple class="drop-activity-modal"
    @before-ok="handleWarningDropActivity"
  >
    <p>删除活动是不可逆的操作，请谨慎操作！</p>
    <a-form
      ref="dropActivityFormRef" :model="dropActivityForm" :label-col-props="{
        span: 6,
      }" :wrapper-col-props="{
        span: 18,
      }"
    >
      <a-form-item
        field="password" label="您的密码" :rules="[{ required: true, message: '请输入密码' }]"
        validate-trigger="blur"
      >
        <a-input-password v-model="dropActivityForm.password" />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { onMounted, reactive, ref } from 'vue'
import { type BreadcrumbRoute, type FormInstance, Message, type ValidatedError } from '@arco-design/web-vue'
import { useRoute, useRouter } from 'vue-router'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type activityRegistrations } from '@/api/adminApi'

dayjs.extend(timezone)
dayjs.extend(utc)

dayjs.tz.setDefault('Asia/Shanghai')

const adminApi = useAdminApi()
const route = useRoute()
const router = useRouter()

const routes: BreadcrumbRoute[] = [
  {
    path: '/admin/manageActivity',
    label: '活动管理'
  },
  {
    path: route.path,
    label: '活动详情'
  }
]

const activityDetail = reactive({
  title: '',
  description: '',
  registrationCount: 0,
  maxParticipants: 0,
  location: '',
  startTime: '1970-01-01T08:00:00+08:00',
  endTime: '1970-01-01T08:00:00+08:00',
  activityTypeName: ''
})

const activityId = Number(route.params.id)

const regUserList = reactive<activityRegistrations[]>([])

async function getActivityDetail(activityId: number) {
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

async function cancelUserReg(userId: number) {
  await handleXhrResponse(() => adminApi.cancelUserReg(activityId, userId), Message)
  Message.success('取消报名成功')
  await getActivityDetail(activityId)
}

const visibleWarning = ref(false)
const dropActivityForm = reactive({
  password: ''
})

const dropActivityFormRef = ref<FormInstance | null>(null)

async function handleWarningDropActivity(done: (closed: boolean) => void) {
  if (dropActivityFormRef.value && dropActivityFormRef.value && !await dropActivityFormRef.value.validate()) {
    await handleXhrResponse(() => adminApi.dropActivity(activityId, dropActivityForm.password), Message)
    Message.success('删除活动成功')
    done(true)
    await router.replace('/admin/manageActivity')
    return
  }
  done(false)
}

onMounted(async () => {
  const activityId = Number(route.params.id)
  await getActivityDetail(activityId)
})

// 修改活动名称
const changeActivityTitle = ref(false)
const changeActivityDescription = ref(false)
const changeActivityLocation = ref(false)
const changeActivityTitleForm = reactive({
  title: ''
})

async function changeActivityTitleCallback() {
  changeActivityTitleForm.title = activityDetail.title
  changeActivityTitle.value = true
}

async function submitChangeActivityTitle(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    // 提交修改活动
    await handleXhrResponse(() => adminApi.modifyActivityTitle(activityId, changeActivityTitleForm.title), Message)
    Message.success('修改活动名称成功')
    changeActivityTitleForm.title = ''
    changeActivityTitle.value = false
    changeActivityDescription.value = false
    changeActivityLocation.value = false
    await getActivityDetail(activityId)
  }
}

// 修改活动详情
const changeActivityDescriptionForm = reactive({
  description: ''
})

async function changeActivityDescriptionCallback() {
  changeActivityDescriptionForm.description = activityDetail.description
  changeActivityDescription.value = true
}

async function submitChangeActivityDescription(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    // 提交修改活动
    await handleXhrResponse(() => adminApi.modifyActivityDescription(activityId, changeActivityDescriptionForm.description), Message)
    Message.success('修改活动描述成功')
    changeActivityDescriptionForm.description = ''
    changeActivityTitle.value = false
    changeActivityDescription.value = false
    changeActivityLocation.value = false
    await getActivityDetail(activityId)
  }
}

// 修改活动地址

const changeActivityLocationForm = reactive({
  location: ''
})

async function changeActivityLocationCallback() {
  changeActivityLocationForm.location = activityDetail.location
  changeActivityLocation.value = true
}

async function submitChangeActivityLocation(form: {
  values: Record<string, any>
  errors: Record<string, ValidatedError> | undefined
}) {
  if (!form.errors) {
    // 提交修改活动
    await handleXhrResponse(() => adminApi.modifyActivityLocation(activityId, changeActivityLocationForm.location), Message)
    Message.success('修改活动地址成功')
    changeActivityLocationForm.location = ''
    changeActivityTitle.value = false
    changeActivityDescription.value = false
    changeActivityLocation.value = false
    await getActivityDetail(activityId)
  }
}
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
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;

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
