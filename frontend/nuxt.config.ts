// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  app: {
    head: {
      htmlAttrs: {
        "data-build-timestamp": new Date().valueOf()
      },
      meta: [
        { charset: "utf-8" },
        {
          name: "viewport",
          content: "width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
        },
        { "http-equiv": "X-UA-Compatible", content: "IE=edge" }
      ]
    }
  },
  plugins: [
    "@/plugins/arco-design"
  ],
  modules: [
    "@pinia/nuxt",
    "@vueuse/nuxt"
  ]
})
