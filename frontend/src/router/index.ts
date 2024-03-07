import { createRouter, createWebHistory, type RouteRecordRaw } from "vue-router"
import { useUserStore } from "@/stores/user"

export enum roles {
  ADMIN = 1,
  USER = 2,
  LOGIN = 9998,
  PUBLIC = 9999
}

type routeRecordWithRole = RouteRecordRaw & {
  meta: {
    roles: roles
  }
}

const routes: Array<routeRecordWithRole> = [
  {
    path: "/",
    redirect: "/index",
    meta: {
      roles: roles.PUBLIC
    }
  },
  {
    path: "/login",
    name: "login",
    component: () => import("@/views/login.vue"),
    meta: {
      roles: roles.PUBLIC
    }
  },
  {
    path: "/",
    name: "defaultLayout",
    component: () => import("@/layouts/default.vue"),
    meta: {
      roles: roles.PUBLIC
    },
    children: [
      {
        path: "/index",
        name: "index",
        component: () => import("@/views/index.vue"),
        meta: {
          roles: roles.PUBLIC
        }
      },
      {
        path: "/user",
        name: "user",
        component: () => import("@/views/user/index.vue"),
        meta: {
          roles: roles.LOGIN
        }
      },
      {
        path: "/noAuth",
        name: "noAuth",
        component: () => import("@/views/noAuth.vue"),
        meta: {
          roles: roles.PUBLIC
        }
      },
      {
        path: "/openSourceLicense",
        name: "openSourceLicense",
        component: () => import("@/views/openSourceLicense.vue"),
        meta: {
          roles: roles.PUBLIC
        }
      },
      // 管理员路由
      {
        path: "/admin",
        name: "admin",
        meta: {
          roles: roles.ADMIN
        },
        children: [
          {
            path: "/admin",
            redirect: "/admin/index"
          },
          {
            path: "/admin/index",
            name: "adminIndex",
            component: () => import("@/views/admin/index.vue"),
            meta: {
              roles: roles.ADMIN
            }
          },
          {
            path: "/admin/manageUser",
            name: "manageUser",
            component: () => import("@/views/admin/manageUser.vue"),
            meta: {
              roles: roles.ADMIN
            }
          },
          {
            path: "/admin/addNewUser",
            name: "addNewUser",
            component: () => import("@/views/admin/addNewUser.vue"),
            meta: {
              roles: roles.ADMIN
            }
          },
          {
            path: "/admin/manageSoloUser/:id",
            name: "manageSoloUser",
            component: () => import("@/views/admin/manageSoloUser.vue"),
            meta: {
              roles: roles.ADMIN
            }
          },
          {
            path: "/admin/manageAssistance",
            name: "manageAssistance",
            component: () => import("@/views/admin/assistanceManage.vue"),
            meta: {
              roles: roles.ADMIN
            }
          },
          {
            path: "/admin/logView",
            name: "logView",
            component: () => import("@/views/admin/logView/index.vue"),
            meta: {
              roles: roles.ADMIN
            },
            children: [
              {
                path: "/admin/logView",
                redirect: "/admin/loginLogView"
              },
              {
                path: "/admin/loginLogView",
                name: "loginLogView",
                component: () => import("@/views/admin/logView/loginLogView.vue"),
                meta: {
                  roles: roles.ADMIN
                }
              }
            ]
          }
        ]
      },
      // 用户路由
      {
        path: "/member",
        name: "member",
        meta: {
          roles: roles.USER
        },
        children: [
          {
            path: "/member",
            redirect: "/member/index"
          },
          {
            path: "/member/index",
            name: "memberIndex",
            component: () => import("@/views/member/index.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/activity",
            name: "memberActivity",
            component: () => import("@/views/member/activity.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/activityDetail/:id",
            name: "memberActivityDetail",
            component: () => import("@/views/member/activityDetail.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/assistance",
            name: "memberAssistance",
            component: () => import("@/views/member/assistance.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/assistanceDetail/:id",
            name: "memberAssistanceDetail",
            component: () => import("@/views/member/assistanceDetail.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/fee",
            name: "memberFee",
            component: () => import("@/views/member/fee.vue"),
            meta: {
              roles: roles.USER
            }
          },
          {
            path: "/member/notification",
            name: "memberNotification",
            component: () => import("@/views/member/notification.vue"),
            meta: {
              roles: roles.USER
            }
          }
        ]
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

router.beforeEach((to, form, next) => {
  const userStore = useUserStore()
  // 权限控制，如果没有权限则跳转到没有权限页面
  // 如果是公共页面则不需要权限
  if (to.meta.roles !== roles.PUBLIC) {
    // 如果该页面需要登录权限
    if ((to.meta.roles === roles.LOGIN && !userStore.isUserLoggedIn) || !userStore.isUserLoggedIn) {
      next({ path: "/login" })
      return
    }
    if (to.meta.roles !== userStore.userInfo.userRole && to.meta.roles !== roles.LOGIN) {
      next({ path: `/noAuth` })
      return
    }
  }
  next()
})


export default router
