<template>
  <a-card class="mb-4">
    <a-button @click="openNewNodeModal('0')">
      添加新节点
    </a-button>
  </a-card>
  <a-card>
    <a-table :columns="columns" :data="permissionList" :pagination="false">
      <template #role_type="{ record }">
        <a-tag v-if="record.role_type === 'R'">
          目录
        </a-tag>
        <a-tag v-if="record.role_type === 'L'">
          页面
        </a-tag>
      </template>
      <template #list_hidden="{ record }">
        <icon-check v-if="record.list_hidden" />
        <icon-close v-else />
      </template>
      <template #action="{ record }">
        <!--        <a-popconfirm content="确定要删除吗？" type="warning" :on-before-ok="handlerDeleteType(record.activity_type_id)"> -->
        <a-space>
          <a-button v-if="record.parent_permission_id === 0" @click="openNewNodeModal(record.permission_id)">
            添加子节点
          </a-button>
          <a-popconfirm
            content="确定要删除吗？" type="warning" :on-before-ok="handlerDeleteNode(record.permission_id)"
          >
            <a-button>删除</a-button>
          </a-popconfirm>
        </a-space>
      </template>
    </a-table>
  </a-card>
  <a-modal v-model:visible="showNewNodeModal" @before-ok="submitNewNode">
    <template #title>
      添加新顶级节点
    </template>
    <a-form ref="newNodeFormRef" :model="newNodeForm" :rules="newNodeRules">
      <a-form-item
        field="parentNode"
        label="父节点"
      >
        <a-select v-model="newNodeForm.parentNode">
          <a-option value="0">
            根节点
          </a-option>
          <a-option v-for="item in permissionList" :key="item.key" :value="Number.parseInt(item.key!)">
            {{ item.description }}
          </a-option>
        </a-select>
      </a-form-item>
      <a-form-item field="permissionNode" label="权限节点">
        <a-input v-model="newNodeForm.permissionNode" />
        <template #extra>
          <div>前端路由地址，动态路由末尾添加*</div>
        </template>
      </a-form-item>
      <a-form-item field="permissionType" label="节点类型">
        <a-input v-model="newNodeForm.permissionType" />
      </a-form-item>
      <a-form-item field="permissionName" label="节点名称">
        <a-input v-model="newNodeForm.permissionName" />
      </a-form-item>
      <a-form-item field="description" label="节点描述">
        <a-input v-model="newNodeForm.description" />
      </a-form-item>
      <a-form-item field="listOrder" label="排序">
        <a-input-number v-model="newNodeForm.listOrder" />
      </a-form-item>
      <a-form-item field="listHidden" label="隐藏菜单">
        <a-radio-group v-model="newNodeForm.listHidden">
          <a-radio :value="true">
            <icon-check />
          </a-radio>
          <a-radio :value="false">
            <icon-close />
          </a-radio>
        </a-radio-group>
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import type { TableColumnData } from '@arco-design/web-vue/es/table/interface'
import { type FieldRule, type FormInstance, Message } from '@arco-design/web-vue'
import useAdminApi, { type PermissionGroupResponse } from '@/api/adminApi'
import { handleXhrResponse } from '@/api'

const columns: TableColumnData[] = [
  {
    title: '权限描述',
    dataIndex: 'description'
  },
  {
    title: '权限节点',
    dataIndex: 'permission_node'
  },
  {
    title: '节点类型',
    slotName: 'role_type'
  },
  {
    title: '排序',
    dataIndex: 'list_order'
  },
  {
    title: '隐藏菜单',
    slotName: 'list_hidden'
  },
  {
    title: '操作',
    slotName: 'action'
  }
]

interface PermissionGroupResponseWithKey extends PermissionGroupResponse {
  key?: string
}

const permissionList = reactive<PermissionGroupResponseWithKey[]>([])
const { getPermissionGroupList } = useAdminApi()

async function fetchPermissionList() {
  const { data } = await handleXhrResponse(() => getPermissionGroupList(0), Message)
  permissionList.splice(0, permissionList.length)
  for (const item of data.data) {
    permissionList.push({
      ...item,
      key: `${item.permission_id}`
    })
  }
  // 将权限列表按照list_order排序
  permissionList.sort((a, b) => a.list_order - b.list_order)
}

onMounted(async () => {
  await fetchPermissionList()
})

const showNewNodeModal = ref(false)
const newNodeRules: Record<string, FieldRule | FieldRule[]> = {
  parentNode: [
    { required: true, message: '请选择父节点' }
  ],
  permissionNode: [
    { required: true, message: '请输入权限节点' }
  ],
  permissionType: [
    { required: true, message: '请输入节点类型' }
  ],
  listOrder: [
    { required: true, message: '请输入排序' }
  ],
  listHidden: [
    { required: true, message: '请选择是否隐藏' }
  ],
  permissionName: [
    { required: true, message: '请输入节点名称' }
  ],
  description: [
    { required: true, message: '请输入节点描述' }
  ]
}
const newNodeForm = reactive({
  parentNode: '',
  permissionNode: '',
  permissionType: '',
  listOrder: 0,
  listHidden: false,
  permissionName: '',
  description: ''
})
function openNewNodeModal(parentNodeId: string) {
  newNodeForm.parentNode = parentNodeId
  showNewNodeModal.value = true
}
const newNodeFormRef = ref<FormInstance | null>(null)
const { newNode, deleteNode } = useAdminApi()
async function submitNewNode(done: (closed: boolean) => void) {
  const res = await newNodeFormRef.value?.validate()
  if (res !== undefined) {
    done(false)
  }
  await handleXhrResponse(() => newNode(
    Number(newNodeForm.parentNode),
    newNodeForm.permissionNode,
    newNodeForm.permissionType,
    newNodeForm.listOrder,
    newNodeForm.listHidden,
    newNodeForm.permissionName,
    newNodeForm.description
  ), Message)
  Message.success('添加成功')
  done(true)
  newNodeFormRef.value?.resetFields()
  await fetchPermissionList()
}

function handlerDeleteNode(id: number) {
  return function (done: (closed: boolean) => void): void | boolean | Promise<void | boolean> {
    return new Promise((resolve) => {
      handleXhrResponse(() => deleteNode(id), Message).then(() => {
        done(true)
        fetchPermissionList()
        resolve()
      }).catch(() => {
        done(false)
        resolve()
      })
    })
  }
}
</script>

<style scoped lang="less">

</style>
