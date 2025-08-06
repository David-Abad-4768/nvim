return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-jest",
      "rcasia/neotest-java",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "pnpm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        },
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
          },
        },
      })
      vim.keymap.set("n", "<leader>tr", function()
        neotest.run.run()
        neotest.summary.open()
      end, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ta", function()
        neotest.run.all()
      end, { noremap = true, silent = true, desc = "[a]ll" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.run.stop()
      end, { noremap = true, silent = true, desc = "[s]top" })

      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open()
      end, { noremap = true, silent = true, desc = "[o]pen output" })

      vim.keymap.set("n", "<leader>tO", function()
        neotest.output.open({ enter = true })
      end, { noremap = true, silent = true, desc = "[O]pen output and enter" })

      vim.keymap.set("n", "<leader>ti", function()
        neotest.summary.toggle()
      end, { noremap = true, silent = true, desc = "[i]nfo" })

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { noremap = true, silent = true, desc = "[f]ile" })

      vim.keymap.set("n", "<leader>tn", function()
        neotest.run.run()
        neotest.summary.open()
      end, { noremap = true, silent = true, desc = "[n]ext" })

      vim.keymap.set("n", "[n", function()
        neotest.jump.prev({ status = "failed" })
      end, { noremap = true, silent = true, desc = "Previous Failed Test" })

      vim.keymap.set("n", "]n", function()
        neotest.jump.next({ status = "failed" })
      end, { noremap = true, silent = true, desc = "Next Failed Test" })
    end,
  },
}
