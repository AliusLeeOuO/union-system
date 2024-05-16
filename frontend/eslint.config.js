import antfu from '@antfu/eslint-config'

export default antfu(
  {
    unocss: true,
    vue: true,
    typescript: true,
    ignores: [
      'public',
      'dist*'
    ],
    stylistic: {
      overrides: {
        'style/comma-dangle': ['error', 'never'],
        'no-console': 'off',
        'brace-style': 'off'
      }
    }
  },
  {
    rules: {
      'eslint-comments/no-unlimited-disable': 'off',
      'curly': ['error', 'all'],
      'antfu/consistent-list-newline': 'off'
    }
  },
  {
    files: [
      'src/**/*.vue'
    ],
    rules: {
      'vue/block-order': ['error', {
        order: ['route', 'template', 'script', 'style']
      }]
    }
  }
)
