-- Function for formatting with the first available LSP server
--
-- I no active LSP servers support it, do nothing
--
local function lspformat()
  local clients = vim.lsp.get_clients({ buffer = 0 })

  -- Loop over clients
  for id, client in pairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({ id = id })
      return
    end
  end
end

return lspformat
