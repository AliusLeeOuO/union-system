import { type RouteRecordRaw, createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { findPermissionNode } from '@/utils/roleHelper'

export enum roles {
  ADMIN = 1,
  USER = 2,
  LOGIN = 9998,
  PUBLIC = 9999
}

type routeRecordWithRole = RouteRecordRaw & {
  meta: {
    roles: roles
    title?: string
  }
}

const routes: Array<routeRecordWithRole> = [
  {
    path: '/',
    redirect: '/index',
    meta: {
      roles: roles.PUBLIC,
      title: '首页'
    }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/login.vue'),
    meta: {
      roles: roles.PUBLIC,
      title: '登录'
    }
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/register.vue'),
    meta: {
      roles: roles.PUBLIC,
      title: '注册'
    }
  },
  {
    path: '/',
    name: 'defaultLayout',
    component: () => import('@/layouts/default.vue'),
    meta: {
      roles: roles.PUBLIC
    },
    children: [
      {
        path: '/index',
        name: 'index',
        component: () => import('@/views/index.vue'),
        meta: {
          roles: roles.PUBLIC,
          title: '首页'
        }
      },
      {
        path: '/user',
        name: 'user',
        component: () => import('@/views/user/index.vue'),
        meta: {
          roles: roles.LOGIN,
          title: '用户中心'
        }
      },
      {
        path: '/noAuth',
        name: 'noAuth',
        component: () => import('@/views/noAuth.vue'),
        meta: {
          roles: roles.PUBLIC,
          title: '没有权限'
        }
      },
      {
        path: '/openSourceLicense',
        name: 'openSourceLicense',
        component: () => import('@/views/openSourceLicense.vue'),
        meta: {
          roles: roles.PUBLIC,
          title: '开源软件许可协议'
        }
      },
      // 管理员路由
      {
        path: '/admin',
        name: 'admin',
        meta: {
          roles: roles.ADMIN
        },
        children: [
          {
            path: '/admin',
            redirect: '/admin/index'
          },
          {
            path: '/admin/index',
            name: 'adminIndex',
            component: () => import('@/views/admin/index.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '首页'
            }
          },
          {
            path: '/admin/user',
            name: 'manageUser',
            component: () => import('@/views/admin/user/index.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '用户管理'
            },
            children: [
              {
                path: '/admin/user',
                redirect: '/admin/user/manage'
              },
              {
                path: '/admin/user/manage',
                name: 'userManage',
                component: () => import('@/views/admin/user/userManage.vue'),
                meta: {
                  title: '用户管理'
                }
              },
              {
                path: '/admin/user/invitationCode',
                name: 'invitationCodeManage',
                component: () => import('@/views/admin/user/invitationCodeManage.vue'),
                meta: {
                  title: '邀请码管理'
                }
              },
              {
                path: '/admin/user/permissionGroup',
                name: 'permissionGroup',
                component: () => import('@/views/admin/user/permissionGroup.vue'),
                meta: {
                  title: '权限组管理'
                }
              },
              {
                path: '/admin/user/permission',
                name: 'permissionNode',
                component: () => import('@/views/admin/user/permissionNode.vue'),
                meta: {
                  title: '权限节点管理'
                }
              }
            ]
          },
          {
            path: '/admin/addNewUser',
            name: 'addNewUser',
            component: () => import('@/views/admin/user/addNewUser.vue'),
            meta: {
              title: '添加用户'
            }
          },
          {
            path: '/admin/manageSoloUser/:id',
            name: 'manageSoloUser',
            component: () => import('@/views/admin/user/manageSoloUser.vue'),
            meta: {
              title: '管理用户'
            }
          },
          {
            path: '/admin/manageAssistance',
            name: 'manageAssistance',
            component: () => import('@/views/admin/assistance/assistanceManage.vue'),
            meta: {
              title: '援助管理'
            }
          },
          {
            path: '/admin/manageAssistance/type',
            name: 'manageAssistanceType',
            component: () => import('@/views/admin/assistance/assistanceTypes.vue'),
            meta: {
              title: '援助类型管理'
            }
          },
          {
            path: '/admin/manageAssistanceDetail/:id',
            name: 'manageAssistanceDetail',
            component: () => import('@/views/admin/assistance/assistanceDetail.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '援助详情'
            }
          },
          {
            path: '/admin/manageActivity',
            name: 'manageActivity',
            component: () => import('@/views/admin/activity/manageActivity.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '活动管理'
            }
          },
          {
            path: '/admin/activity/type',
            name: 'activityType',
            component: () => import('@/views/admin/activity/manageTypes.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '活动类型管理'
            }
          },
          {
            path: '/admin/management',
            name: 'log',
            component: () => import('@/views/admin/management/index.vue'),
            meta: {
              roles: roles.ADMIN,
              title: '日志'
            },
            children: [
              {
                path: '/admin/management',
                redirect: '/admin/management/loginLog'
              },
              {
                path: '/admin/management/loginLog',
                name: 'loginLog',
                component: () => import('@/views/admin/management/loginLogView.vue'),
                meta: {
                  roles: roles.ADMIN,
                  title: '登录日志'
                }
              },
              {
                path: '/admin/management/adminActionLog',
                name: 'adminActionLog',
                component: () => import('@/views/admin/management/adminActionLog.vue'),
                meta: {
                  roles: roles.ADMIN,
                  title: '管理员操作日志'
                }
              },
              {
                path: '/admin/management/userActionLog',
                name: 'userActionLog',
                component: () => import('@/views/admin/management/memberActionLog.vue'),
                meta: {
                  roles: roles.ADMIN,
                  title: '用户操作日志'
                }
              },
              {
                path: '/admin/management/systemInfo',
                name: 'systemInfo',
                component: () => import('@/views/admin/management/systemInfo.vue'),
                meta: {
                  roles: roles.ADMIN,
                  title: '系统信息'
                }
              }
            ]
          },
          {
            path: '/admin/fee',
            name: 'adminFeeManagement',
            component: () => import('@/views/admin/fee/index.vue'),
            meta: {
              title: '会费管理'
            },
            children: [
              {
                path: '/admin/fee',
                redirect: '/admin/fee/registeredMember'
              },
              {
                path: '/admin/fee/feeSetting',
                name: 'feeSetting',
                component: () => import('@/views/admin/fee/feeStandardList.vue'),
                meta: {
                  title: '会费标准管理'
                }
              },
              {
                path: '/admin/fee/registeredMember',
                name: 'registeredMember',
                component: () => import('@/views/admin/fee/registeredMember.vue'),
                meta: {
                  title: '已注册会员管理'
                }
              },
              {
                path: '/admin/fee/nonRegisteredMember',
                name: 'nonRegisteredMember',
                component: () => import('@/views/admin/fee/nonRegisteredMember.vue'),
                meta: {
                  title: '未注册会员管理'
                }
              },
              {
                path: '/admin/fee/bills',
                name: 'adminBills',
                component: () => import('@/views/admin/fee/bills.vue'),
                meta: {
                  title: '账单管理'
                }
              }
            ]
          }
        ]
      },
      // 用户路由
      {
        path: '/member',
        name: 'member',
        meta: {
          roles: roles.USER
        },
        children: [
          {
            path: '/member',
            redirect: '/member/index'
          },
          {
            path: '/member/index',
            name: 'memberIndex',
            component: () => import('@/views/member/index.vue'),
            meta: {
              title: '首页'
            }
          },
          {
            path: '/member/activity',
            name: 'memberActivity',
            component: () => import('@/views/member/activity/index.vue'),
            meta: {
              title: '活动'
            },
            children: [
              {
                path: '/member/activity',
                redirect: '/member/activity/plaza'
              },
              {
                path: '/member/activity/plaza',
                name: 'activityPlaza',
                component: () => import('@/views/member/activity/activityPlaza.vue'),
                meta: {
                  title: '活动广场'
                }
              },
              {
                path: '/member/activity/my',
                name: 'activityMy',
                component: () => import('@/views/member/activity/myActivity.vue'),
                meta: {
                  title: '我的活动'
                }
              }
            ]
          },
          {
            path: '/member/activityDetail/:id',
            name: 'memberActivityDetail',
            component: () => import('@/views/member/activity/activityDetail.vue'),
            meta: {
              title: '活动详情'
            }
          },
          {
            path: '/member/assistance',
            name: 'memberAssistance',
            component: () => import('@/views/member/assistance/index.vue'),
            meta: {
              title: '援助'
            },
            children: [
              {
                path: '/member/assistance',
                redirect: '/member/assistance/myAssistance'
              },
              {
                path: '/member/assistance/myAssistance',
                name: 'myAssistance',
                component: () => import('@/views/member/assistance/myAssistance.vue'),
                meta: {
                  title: '我的援助'
                }
              },
              {
                path: '/member/assistance/newAssistance',
                name: 'newAssistance',
                component: () => import('@/views/member/assistance/newAssistance.vue'),
                meta: {
                  title: '新援助'
                }
              }
            ]
          },
          {
            path: '/member/assistance/assistanceDetail/:id',
            name: 'memberAssistanceDetail',
            component: () => import('@/views/member/assistance/assistanceDetail.vue'),
            meta: {
              title: '援助详情'
            }
          },
          {
            path: '/member/fee',
            name: 'memberFee',
            component: () => import('@/views/member/fee.vue'),
            meta: {
              title: '会费'
            }
          },
          {
            path: '/member/notification',
            name: 'memberNotification',
            component: () => import('@/views/member/notification.vue'),
            meta: {
              title: '通知'
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
      next({ path: '/login' })
      return
    }
    if (!findPermissionNode(userStore.userPermissions, to.path)) {
      next({ path: `/noAuth` })
      return
    }
  }
  // 更改标题
  if (to.meta.title !== undefined) {
    document.title = `${to.meta.title} - 工会管理系统`
  }
  else {
    document.title = '工会管理系统'
  }

  next()
})

export default router
