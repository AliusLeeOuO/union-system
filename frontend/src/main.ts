import { createApp } from "vue"
import { createPinia } from "pinia"
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import ClickOutside from './directives/clickoutside'

import "./assets/main.less"
import { Message } from '@arco-design/web-vue'
import 'virtual:uno.css'

import App from "./App.vue"
import router from "./router"

const piniaInstance = createPinia()
piniaInstance.use(piniaPluginPersistedstate)

const app = createApp(App)
  .use(piniaInstance)
  .use(router)
  .directive("click-outside", ClickOutside)
  .mount("#app")

