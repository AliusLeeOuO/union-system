export enum roles {
  ADMIN = 1,
  USER = 2
}

export function getRoleName(role: roles): string {
  switch(role) {
    case roles.ADMIN:
      return "管理员";
    case roles.USER:
      return "用户";
    default:
      return "未知角色";
  }
}