<template>
  <a-card class="mb-4">
    <a-button @click="openNewNodeModal('0')">
      编辑节点
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
    </a-table>
  </a-card>
  <a-modal v-model:visible="showNewNodeModal" @before-ok="submitNewNodeModal" @before-open="insertFormItem">
    <template #title>
      编辑节点
    </template>
    <a-form ref="modifyFormRef" :model="updateNodesForm">
      <a-form-item field="permissionList" label="权限组" extra="在给子节点授权时，请先给父节点授权，否则子节点的权限会被直接丢弃。">
        <!--   checkbox树形，根据permissionList和permissionList.children   -->
        <a-checkbox-group v-model="updateNodesForm.permissionList">
          <div class="flex flex-col gap-2">
            <div v-for="item in allowPermissionList" :key="item.permission_id">
              <a-checkbox :value="item.permission_id">
                {{ item.description }}
              </a-checkbox>
              <div v-if="item.children && item.children.length">
                <a-checkbox v-for="child in item.children" :key="child.permission_id" :value="child.permission_id">
                  {{ child.description }}
                </a-checkbox>
              </div>
            </div>
          </div>
        </a-checkbox-group>
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import type { TableColumnData } from '@arco-design/web-vue/es/table/interface'
import { type FormInstance, Message } from '@arco-design/web-vue'
import useAdminApi, { type PermissionGroupResponse } from '@/api/adminApi'
import { handleXhrResponse } from '@/api'

const props = defineProps<{
  roleId: number
  allowRoleType: string
}>()

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
  }
]

interface PermissionGroupResponseWithKey extends PermissionGroupResponse {
  key?: string
}

const permissionList = reactive<PermissionGroupResponseWithKey[]>([])
const { getPermissionGroupList, getPermissionNodeByRoleType, updatePermissionGroupNode } = useAdminApi()

async function fetchPermissionList() {
  const { data } = await handleXhrResponse(() => getPermissionGroupList(props.roleId), Message)
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

const newNodeForm = reactive({
  parentNode: '',
  permissionNode: '',
  roleType: '',
  listOrder: 0,
  listHidden: false
})
function openNewNodeModal(parentNodeId: string) {
  newNodeForm.parentNode = parentNodeId
  showNewNodeModal.value = true
}
const updateNodesForm = reactive<{ permissionList: number[] }>({ permissionList: [] })
async function submitNewNodeModal(done: (closed: boolean) => void) {
  try {
    await handleXhrResponse(() => updatePermissionGroupNode(props.roleId, updateNodesForm.permissionList), Message)
    done(true)
    await fetchPermissionList()
  }
  catch (e) {
    done(false)
  }
}

function setSelectedPermissions() {
  const selectedPermission: number[] = []
  const findSelectedPermission = (node: PermissionGroupResponse) => {
    selectedPermission.push(node.permission_id)
    if (node.children) {
      for (const child of node.children) {
        findSelectedPermission(child)
      }
    }
  }
  permissionList.forEach(node => findSelectedPermission(node))
  updateNodesForm.permissionList = selectedPermission
}

const modifyFormRef = ref<FormInstance | null>(null)

function insertFormItem() {
  setSelectedPermissions()
}

const allowPermissionList = reactive<PermissionGroupResponse[]>([])
async function fetchAllowPermissionList() {
  const { data } = await handleXhrResponse(() => getPermissionNodeByRoleType(props.allowRoleType), Message)
  allowPermissionList.splice(0, allowPermissionList.length, ...data.data)
  // 将权限列表按照list_order排序
  allowPermissionList.sort((a, b) => a.list_order - b.list_order)
}
onMounted(async () => {
  await fetchAllowPermissionList()
})
</script>

<style scoped lang="less">

</style>
