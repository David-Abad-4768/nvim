return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = " " },
        TODO = { icon = " " },
        HACK = { icon = " " },
        WARN = { icon = " " },
        PERF = { icon = " " },
        NOTE = { icon = " " },
        TEST = { icon = "⏲ " },
      },
    }
  }
}
