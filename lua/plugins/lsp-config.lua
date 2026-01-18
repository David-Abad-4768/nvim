return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:Crashdummyy/mason-registry",
          "github:mason-org/mason-registry",
        },
        ensure_installed = { "stylua", "prettier", "ruff_format", "shfmt", "clang-format" },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "roslyn", "rzls", "html", "lua_ls", "ts_ls" },
        automatic_installation = true,
      })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "java-debug-adapter", "java-test", "codelldb" },
      })
    end,
  },

  { "mfussenegger/nvim-jdtls", dependencies = { "mfussenegger/nvim-dap" } },

  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    lazy = false,
    config = function() require("tailwindcss-colors").setup() end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = { "tris203/rzls.nvim" },
    init = function()
      vim.filetype.add({
        extension = { razor = "razor", cshtml = "razor" },
      })
    end,
    config = function()
      local rzls_path = vim.fn.stdpath("data") .. "/mason/packages/rzls/libexec"
      local cmd = {
        "roslyn", "--stdio", "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension=" .. vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      }

      require("roslyn").setup({
        cmd = cmd,
        handlers = require("rzls.roslyn_handlers"),
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
          },
          ["csharp|code_lens"] = { dotnet_enable_references_code_lens = true },
        },
      })
    end,
  },

  {
    "mrshmllow/document-color.nvim",
    config = function() require("document-color").setup({ mode = "background" }) end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      -- NUEVO: Capacidades de Blink (Más rápidas que nvim-cmp)
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.colorProvider = { dynamicRegistration = true }

      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        if client.server_capabilities.semanticTokensProvider then
          client.server_capabilities.semanticTokensProvider = nil
        end
        if client.server_capabilities.colorProvider then
          require("document-color").buf_attach(bufnr)
        end
      end

      -- Configuración global Neovim 0.11
      vim.lsp.config("*", {
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      local servers = { "html", "lua_ls", "ts_ls", "roslyn", "rzls" }
      for _, name in ipairs(servers) do
        vim.lsp.enable(name)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function() require("config.jdtls").setup_jdtls() end,
      })

      -- Diagnósticos Optimizados
      vim.diagnostic.config({
        virtual_text = { prefix = "●", severity = { min = vim.diagnostic.severity.INFO } },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "󰠠",
            [vim.diagnostic.severity.INFO]  = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Handler para silenciar errores JSON irrelevantes
      local orig_handler = vim.lsp.handlers["window/showMessage"]
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, cfg)
        if result and result.message and result.message:match("failed to decode json") then return end
        return orig_handler(_, result, ctx, cfg)
      end
    end,
  },
}
