return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        size = 15,
        open_mapping = [[<c-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          }
        }
      })

      vim.api.nvim_set_keymap("n", "<leader>tt", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>tn", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>tp", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>wincmd h<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>j", "<cmd>wincmd j<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>k", "<cmd>wincmd k<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>wincmd l<CR>", { noremap = true, silent = true })
    end
  }
}

