return {
	{
		"mistricky/codesnap.nvim",
		lazy = true,
		build = "make",
		cmd = { "CodeSnapPreviewOn", "CodeSnapPreviewOff", "CodeSnap", "CodeSnapSave" },
		config = function(_, opts)
			require("codesnap").setup({
				bg_padding = 0,
				has_breadcrumbs = true,
			})
		end,
		keys = {
			{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
			{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
		},
	},
}
