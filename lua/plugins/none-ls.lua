return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local lsp_util = require("lspconfig.util")
    local function has_file(files)
      return lsp_util.root_pattern(unpack(files))(vim.fn.getcwd()) ~= nil
    end
    local sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.typstfmt,
      null_ls.builtins.formatting.asmfmt,
      null_ls.builtins.diagnostics.erb_lint,
    }
    if has_file({ "biome.json", "biome.jsonc" }) then
      local ok_fmt, biome_fmt = pcall(require, "none-ls-extras.formatting.biome")
      local ok_diag, biome_diag = pcall(require, "none-ls-extras.diagnostics.biome")
      if ok_fmt then
        table.insert(sources, biome_fmt)
      end
      if ok_diag then
        table.insert(sources, biome_diag)
      end
    else
      if has_file({ ".prettierrc", ".prettierrc.json", ".prettierrc.js" }) then
        table.insert(sources, null_ls.builtins.formatting.prettier)
      end
      if has_file({ ".eslintrc.json", ".eslintrc.js" }) then
        local ok_eslint, eslint_diag = pcall(require, "none-ls-extras.diagnostics.eslint_d")
        if ok_eslint then
          table.insert(sources, eslint_diag)
        end
      end
    end
    null_ls.setup({ sources = sources })
    vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
  end,
}
