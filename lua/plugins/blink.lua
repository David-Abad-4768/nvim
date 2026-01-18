return {
  {
    'saghen/blink.cmp',
    version = 'v1.*',
    -- Se eliminó la línea 'build' para evitar el intento fallido de compilación con Rust
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'saghen/blink.compat', opts = {} },
    },
    opts = {
      -- CORRECCIÓN APLICADA: Forzar el uso de Lua para eliminar el error del binario faltante
      fuzzy = {
        implementation = "lua"
      },

      -- Usamos el motor de snippets nativo de Neovim
      snippets = { preset = 'default' },

      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          sql = { 'dadbod', 'buffer' },
          mysql = { 'dadbod', 'buffer' },
          plsql = { 'dadbod', 'buffer' },
        },
        providers = {
          dadbod = {
            name = 'Dadbod',
            module = 'blink.compat.source',
            score_offset = 100,
          },
        },
      },

      completion = {
        menu = { border = 'rounded' },
        documentation = { window = { border = 'rounded' }, auto_show = true },
        ghost_text = { enabled = true },
      },
    },
  },
}
