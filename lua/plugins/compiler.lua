return {
  { 
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
    opts = {
      targets = {
        maven_compile = "make maven_compile",   
        maven_build_and_run = "make maven_build_and_run",
        maven_run = "make maven_run",
      },
      float = {
        width = 0.8,
        height = 0.8,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      }
    },
  },
  {
    "stevearc/overseer.nvim",
    commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "top",
        min_height = 25,
        max_height = 25,
        default_detail = 1
      },
      float = {
        width = 0.8,
        height = 0.8,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      }
    },
  },
  { 
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup{
        defaults = {
          layout_config = {
            prompt_position = "top",
            preview_cutoff = 120,
            width = 0.75,
            height = 0.75,
          },
          winblend = 0,
        }
      }
    end,
  },
}
