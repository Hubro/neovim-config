local restore_view = require("hubro.restore_view")

-- Function for formatting with the first available LSP server
--
-- If no active LSP servers support it, do nothing
--
local function lspformat()
  -- Sometimes I have to use older Neovim versions...
  if vim.lsp.get_clients == nil then
    vim.lsp.buf.format()
    return
  end

  local clients = vim.lsp.get_clients({ buffer = 0 })

  -- Loop over clients
  for id, client in pairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      restore_view(function()
        vim.lsp.buf.format({ id = id })
      end)
    end
  end
end

return lspformat
