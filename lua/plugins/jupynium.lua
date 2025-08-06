return {
  {
    "kiyoon/jupynium.nvim",
    event = "BufReadPre *.ju.*",
    config = function()
      require("jupynium").setup({
        default_notebook_URL = "localhost:8888/nbclassic",
      })
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
  },
}
