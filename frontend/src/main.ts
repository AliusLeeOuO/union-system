import { createApp } from "vue"
import { createPinia } from "pinia"
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import ClickOutside from './directives/clickoutside'

import "./assets/main.less"

import App from "./App.vue"
import router from "./router"

const piniaInstance = createPinia()
piniaInstance.use(piniaPluginPersistedstate)

createApp(App)
  .use(piniaInstance)
  .use(router)
  .directive("click-outside", ClickOutside)
  .mount("#app")
