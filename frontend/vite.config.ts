import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"

import Components from "unplugin-vue-components/vite"
import { ArcoResolver } from "unplugin-vue-components/resolvers"
import AutoImport from "unplugin-auto-import/vite"
import { createHtmlPlugin } from "vite-plugin-html"
import UnoCSS from 'unocss/vite'


// https://vitejs.dev/config/
export default defineConfig({
  base: "./",
  plugins: [
    vue(),
    UnoCSS(),
    Components({
      resolvers: [ArcoResolver({
        sideEffect: true
      })],
      dts: true
    }),
    AutoImport({
      resolvers: [ArcoResolver()]
    }),
    createHtmlPlugin({
      minify: true
    })
  ],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url))
    }
  }
})
