return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = { "lua", "javascript", "typescript", "xml", "json", "html", "python", "regex",  "query"},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
      rainbow = {
        enable = true,
        query = 'rainbow-parens'
      },
		})
	end,
}
