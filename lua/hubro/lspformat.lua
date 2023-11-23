-- Function for formatting with the first available LSP server
--
-- If no active LSP servers support it, do nothing
--
local function lspformat()
  local clients = vim.lsp.get_clients({ buffer = 0 })

  -- Loop over clients
  for id, client in pairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      local view = vim.fn.winsaveview()
      vim.lsp.buf.format({ id = id })
      vim.fn.winrestview(view)
      return
    end
  end
end

return lspformat