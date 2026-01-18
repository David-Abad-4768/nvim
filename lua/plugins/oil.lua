return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<C-m>",
				function()
					require("oil").open()
				end,
				desc = "Abrir explorador de archivos Oil",
			},
		},
	},
}
