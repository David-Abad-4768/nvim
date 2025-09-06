return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:Crashdummyy/mason-registry",
          "github:mason-org/mason-registry",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "roslyn",
          "lua_ls",
          "ts_ls",
          "tailwindcss",
        },
      })
    end,
  },
  {
    "seblyng/roslyn.nvim",
    opts = {
      filewatching = "auto",
      silent = false,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "java-debug-adapter",
          "java-test",
          "codelldb",
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    lazy = false,
    config = function()
      require("tailwindcss-colors").setup()
    end,
  },
  {
    "mrshmllow/document-color.nvim",
    config = function()
      require("document-color").setup({
        mode = "background",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.colorProvider = { dynamicRegistration = true }

      local on_attach = function(client, bufnr)
        if client.server_capabilities.semanticTokensProvider then
          client.server_capabilities.semanticTokensProvider = nil
        end

        if client.server_capabilities.colorProvider then
          require("document-color").buf_attach(bufnr)
        end
      end

      local servers = {
        "ts_ls",
        "cssls",
        "html",
        "lua_ls",
        "nextls",
        "tailwindcss",
        "pylsp",
        "eslint",
        "quick_lint_js",
        "emmet_ls",
        "prismals",
        "cucumber_language_server",
        "svelte",
        "dockerls",
        "docker_compose_language_service",
        "clangd",
        "yamlls",
        "jsonls",
        "bashls",
      }

      for _, server in ipairs(servers) do
        if lspconfig[server] then
          lspconfig[server].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        else
          vim.notify("LSP server not found in lspconfig: " .. server, vim.log.levels.WARN)
        end
      end

      -- Java-specific
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("config.jdtls").setup_jdtls()
        end,
      })

      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          severity = { min = vim.diagnostic.severity.INFO },
        },
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

      local orig_handler = vim.lsp.handlers["window/showMessage"]
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, config)
        if result and result.message and result.message:match("failed to decode json") then
          return
        end
        return orig_handler(_, result, ctx, config)
      end
    end,
  },
}
