import type { permissionResponseData } from "@/api/userApi"

export enum roles {
  ADMIN = 1,
  USER = 2
}

export function getRoleName(role: roles): string {
  switch (role) {
    case roles.ADMIN:
      return "管理员"
    case roles.USER:
      return "用户"
    default:
      return "未知角色"
  }
}


// 递归查找权限节点，如果找到则返回当前节点，否则返回 null
// 递归查找权限节点，如果找到则返回当前节点，否则返回 null
export const findPermissionNode = (permissions: permissionResponseData[], permissionNode: string): permissionResponseData | null => {
  for (let i = 0; i < permissions.length; i++) {
    if (permissions[i].permission_node === permissionNode) {
      return permissions[i]
    }
    // 如果权限节点以 "*" 结尾，那么将其视为通配符节点
    if (permissions[i].permission_node.endsWith('*')) {
      const baseNode = permissions[i].permission_node.slice(0, -1); // 去掉末尾的 "*"
      if (permissionNode.startsWith(baseNode)) {
        return permissions[i]
      }
    }
    if (permissions[i].children) {
      const foundNode = findPermissionNode(permissions[i].children!, permissionNode)
      if (foundNode) {
        return foundNode
      }
    }
  }
  return null
}
