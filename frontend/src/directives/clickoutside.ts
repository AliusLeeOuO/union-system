// 导入Vue所需的类型，DirectiveBinding用于指令绑定信息，ObjectDirective用于定义Vue指令对象
import type { DirectiveBinding, ObjectDirective } from 'vue'

// 定义DocumentHandler类型，这是一个用于处理MouseEvent的函数类型
type DocumentHandler = <T extends MouseEvent>(e: T) => void

// 定义ListProps接口，用于存储documentHandler函数
interface ListProps {
  documentHandler?: DocumentHandler
}

// nodeList用于存储当前活动的documentHandler
let nodeList: ListProps = {}

// createDocumentHandler函数生成一个处理点击事件的函数
// 这个函数用于判断点击是否发生在绑定元素的外部，并执行相应的操作
function createDocumentHandler(
  el: HTMLElement,
  binding: DirectiveBinding
): DocumentHandler {
  return function (e: MouseEvent) {
    const target = e.target as HTMLElement
    // 如果点击的是绑定元素内部的部分，不执行任何操作
    if (el.contains(target)) {
      return false
    }

    // 如果绑定了函数（通过v-click-outside="myFunction"这样的语法），则执行该函数
    if (binding.arg) {
      binding.value(e)
    }
  }
}

// 全局的事件处理函数，用于处理所有点击事件
function handler(e: MouseEvent) {
  const { documentHandler } = nodeList
  if (documentHandler) {
    documentHandler(e)
  }
}

// 在window对象上添加点击事件监听器
// 这个监听器会处理所有的点击事件，然后委托给指令的处理函数
window.addEventListener('click', handler)

// 定义Vue指令ClickOutSide
const ClickOutSide: ObjectDirective = {
  // beforeMount生命周期钩子，在指令首次绑定到元素时调用
  beforeMount(el, binding) {
    // 设置documentHandler来处理点击事件
    nodeList = {
      documentHandler: createDocumentHandler(el, binding)
    }
  },
  // updated生命周期钩子，当指令所在组件的VNode更新时调用
  updated(el, binding) {
    // 更新documentHandler来处理新的点击事件
    nodeList = {
      documentHandler: createDocumentHandler(el, binding)
    }
  },
  // unmounted生命周期钩子，在指令与元素解绑时调用
  unmounted() {
    // 移除window上的事件监听器，防止内存泄漏
    window.removeEventListener('click', handler)
  }
}

// 导出ClickOutSide指令
export default ClickOutSide
