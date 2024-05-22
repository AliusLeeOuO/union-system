/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_API_PROTOCOL: 'http' | 'https'
  readonly VITE_WS_PROTOCOL: 'ws' | 'wss'
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
