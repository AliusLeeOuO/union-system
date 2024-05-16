import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import ArcoVueIcon from '@arco-design/web-vue/es/icon'
import ClickOutside from './directives/clickoutside'
import './assets/main.less'
import 'virtual:uno.css'

import App from './App.vue'
import router from './router'

const piniaInstance = createPinia()
piniaInstance.use(piniaPluginPersistedstate)

createApp(App)
  .use(piniaInstance)
  .use(router)
  .use(ArcoVueIcon)
  .directive('click-outside', ClickOutside)
  .mount('#app')
