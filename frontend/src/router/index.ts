import { createRouter, createWebHistory, type RouteRecordRaw } from "vue-router"
import { useUserStore } from "@/stores/user"

export enum roles {
  FINANCE = 1,
  ADMIN = 2,
  USER = 3,
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
  // 权限控制，如果没有权限则跳转到404
  // 如果是公共页面则不需要权限
  if (to.meta.roles !== roles.PUBLIC) {
    // 如果没有登录则跳转到登录页面
    if (userStore.userInfo.token.length === 0) {
      next({ path: "/login" })
      return
    }
    if (to.meta.roles !== userStore.userInfo.userRole) {
      next({ path: `/noAuth` })
      return
    }
  }
  next()
})


export default router
