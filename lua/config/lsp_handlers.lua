local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.colorProvider = { dynamicRegistration = true }

M.on_attach = function(client, bufnr)
  if client.server_capabilities.semanticTokensProvider then
    client.server_capabilities.semanticTokensProvider = nil
  end

  if client.server_capabilities.colorProvider then
    require("document-color").buf_attach(bufnr)
  end
end

return M
