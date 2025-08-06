return {
  "EdenEast/nightfox.nvim",
  name = "nightfox",
  priority = 1000,
  config = function()
    require("nightfox").setup({
      options = {
        transparent = true,
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    })
    vim.cmd.colorscheme "nightfox"
  end,
}
