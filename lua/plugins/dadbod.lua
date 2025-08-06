return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notification = 1

    vim.g.db_ui_table_helpers = {
      mysql = {
        Count = "select count(1) from {optional_schema}{table}",
        Explain = "Explain {last_query}",
      },
    }

    vim.g.db_ui_icons = {
      expanded = {
        buffers = "▾ ",
        saved_queries = "▾ ",
        schemas = "▾ ",
        schema = "▾ ☲",
        tables = "▾ ☵",
        table = "▾ ",
      },
      collapsed = {
        db = "▸ ",
        buffers = "▸ ",
        saved_queries = "▸ ",
        schemas = "▸ ",
        schema = "▸ ⊟",
        tables = "▸ ☵",
        table = "▸ ",
      },
      saved_query = "",
      new_query = "＋",
      tables = "☵",
      connection_ok = "✓",
      connection_error = "✕",
    }

    vim.keymap.set("n", "<C-d>", ":tab DBUI<cr>", {})
    vim.keymap.set("n", "<C-q>", ":tabclose<cr>")
  end,
}
