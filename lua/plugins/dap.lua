return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"mfussenegger/nvim-dap",

		keys = {
			{
				"<Leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "DAP: Poner breakpoint",
			},
			{
				"<Leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "DAP: Continuar",
			},
			{
				"<Leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "DAP: Step Over",
			},
			{
				"<Leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "DAP: Step Into",
			},
			{
				"<Leader>du",
				function()
					require("dap").step_out()
				end,
				desc = "DAP: Step Out",
			},
			{
				"<Leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "DAP: Abrir REPL",
			},
			{
				"<Leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "DAP: Ejecutar última sesión",
			},
			{
				"<Leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "DAP: Terminar sesión",
			},
			{
				"<Leader>dui",
				function()
					require("dapui").toggle()
				end,
				desc = "DAP: Alternar UI",
			},
		},

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"williamboman/mason.nvim",

			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mfussenegger/nvim-dap" },
				opts = {
					ensure_installed = {
						"cpptools", -- Para C/C++
						"netcoredbg", -- Para C#
					},
					automatic_installation = true,
					handlers = {},
				},
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					breakpoint = "●",
					rejectedBreakpoint = "",
					stopped = "",
				},

				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			dap.listeners.after.main.fn = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.fn = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.fn = function()
				dapui.close()
			end
		end,
	},
}
