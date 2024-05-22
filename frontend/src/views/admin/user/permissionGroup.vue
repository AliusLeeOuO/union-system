<template>
  <a-card class="mb-4">
    <a-button status="success" @click="openNewPermissionGroupModal">
      添加新权限组
    </a-button>
  </a-card>
  <a-card>
    <a-table :columns="columns" :data="permissionGroupList" :expandable="expandable" :pagination="false">
      <template #allow_account_type="{ record }">
        <a-tag>{{ getRoleName(record.allow_account_type) }}</a-tag>
      </template>
      <template #action="{ record }">
        <a-popconfirm content="确定要删除吗？" type="warning" :on-before-ok="handlerDeletePermissionGroup(record.type_id)">
          <a-button type="primary" status="danger">
            删除
          </a-button>
        </a-popconfirm>
      </template>
    </a-table>
  </a-card>
  <a-modal v-model:visible="newPermissionGroupVisible" @before-ok="handleNewPermissionGroup">
    <template #title>
      添加新权限组
    </template>
    <a-form ref="newPermissionGroupFormRef" :model="newPermissionGroupForm" :rules="newPermissionGroupRule">
      <a-form-item field="typeName" label="节点标识">
        <a-input v-model="newPermissionGroupForm.typeName" />
      </a-form-item>
      <a-form-item field="description" label="节点名称">
        <a-input v-model="newPermissionGroupForm.description" />
      </a-form-item>
      <a-form-item field="allowRoleType" label="允许角色">
        <a-select v-model="newPermissionGroupForm.allowRoleType">
          <a-option value="ADMIN">
            管理员
          </a-option>
          <a-option value="MEMBER">
            会员
          </a-option>
        </a-select>
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script lang="ts" setup>
import { h, onMounted, reactive, ref } from 'vue'
import type { TableColumnData, TableExpandable } from '@arco-design/web-vue/es/table/interface'
import { type FieldRule, type FormInstance, Message } from '@arco-design/web-vue'
import { getRoleName } from '@/utils/roleHelper'
import { handleXhrResponse } from '@/api'
import useAdminApi, { type allowPermissionGroupResponse } from '@/api/adminApi'
import permissionListTable from '@/components/permissionListTable.vue'

// 给allowPermissionGroupResponse添加一个属性，用于展示额外数据
interface allowPermissionGroup extends allowPermissionGroupResponse {
  expand: any
  key: string
}

const columns: TableColumnData[] = [
  {
    title: '权限组ID',
    dataIndex: 'type_id'
  },
  {
    title: '允许角色',
    slotName: 'allow_account_type'
  },
  {
    title: '权限组说明',
    dataIndex: 'description'
  },
  {
    title: '操作',
    slotName: 'action'
  }
]

const permissionGroupList = reactive<allowPermissionGroup[]>([])
const { getRoleGroupList } = useAdminApi()
async function fetchPermissionGroupList() {
  const { data } = await handleXhrResponse(() => getRoleGroupList(), Message)
  permissionGroupList.splice(0)
  for (const item of data.data) {
    permissionGroupList.push({
      ...item,
      key: item.type_id.toString(),
      expand: h(
        'div',
        {
          class: [
            'p-2'
          ]
        },
        [
          h(permissionListTable, {
            roleId: item.type_id,
            allowRoleType: item.allow_account_type
          })
        ]
      )
    })
  }
}

const expandable: TableExpandable = {
  width: 30
}

onMounted(async () => {
  await fetchPermissionGroupList()
})

const newPermissionGroupVisible = ref(false)
const newPermissionGroupFormRef = ref<FormInstance | null>(null)
const newPermissionGroupRule: Record<string, FieldRule | FieldRule[]> = {
  typeName: [
    { required: true, message: '请输入节点标识' }
  ],
  description: [
    { required: true, message: '请输入节点名称' }
  ],
  allowRoleType: [
    { required: true, message: '请选择允许角色' }
  ]
}
const newPermissionGroupForm = reactive({
  typeName: '',
  description: '',
  allowRoleType: ''
})
function openNewPermissionGroupModal() {
  newPermissionGroupVisible.value = true
}
const { addNewPermissionGroup, deletePermissionGroup } = useAdminApi()
async function handleNewPermissionGroup(done: (closed: boolean) => void) {
  const res = await newPermissionGroupFormRef.value?.validate()
  if (res !== undefined) {
    done(false)
    return
  }
  try {
    await handleXhrResponse(() => addNewPermissionGroup(
      newPermissionGroupForm.typeName,
      newPermissionGroupForm.description,
      newPermissionGroupForm.allowRoleType
    ), Message)
    Message.success('添加成功')
    done(true)
    await fetchPermissionGroupList()
  }
  catch (e: any) {
    console.error(e)
    done(false)
  }
}

function handlerDeletePermissionGroup(typeId: number) {
  return function (done: (closed: boolean) => void): void | boolean | Promise<void | boolean> {
    // eslint-disable-next-line no-async-promise-executor
    return new Promise(async (resolve, reject) => {
      try {
        await handleXhrResponse(() => deletePermissionGroup(typeId), Message)
        Message.success('删除成功')
        await fetchPermissionGroupList()
        done(true)
        resolve(true)
      }
      catch (e: any) {
        console.error(e)
        done(false)
        reject(e)
      }
    })
  }
}
</script>
