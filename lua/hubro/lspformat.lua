local restore_view = require("hubro.restore_view")

local default_priority = 50

local formatting_priorities = {
  svelte = 100,
  ruff = 70,
  efm = 60,
}

--- Selects one LSP client to use for formatting
---@param lsp_clients table<vim.lsp.Client>
---@return vim.lsp.Client
local function _select_formatter(lsp_clients)
  local winner
  local prio = 0

  for _, client in ipairs(lsp_clients) do
    local client_name = client.name
    local client_prio = default_priority

    if formatting_priorities[client_name] ~= nil then
      client_prio = formatting_priorities[client_name]
    end

    if client_prio > prio then
      prio = client_prio
      winner = client
    elseif client_prio == prio then
      vim.notify(
        "More than one connected LSP server has the same formatting priority",
        vim.log.levels.WARN
      )
    end
  end

  return winner
end

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

  local buf = vim.api.nvim_get_current_buf()

  local clients = {}

  for _, client in ipairs(vim.lsp.get_clients()) do
    if vim.lsp.buf_is_attached(buf, client.id)
        and client.supports_method("textDocument/formatting")
        and client.server_capabilities.documentFormattingProvider then
      table.insert(clients, client)
    end
  end

  if #clients == 0 then
    vim.notify("No attached LSP clients supports textDocument/formatting")
    return
  end

  --- @type vim.lsp.Client
  local formatting_client

  if #clients > 1 then
    formatting_client = _select_formatter(clients)
  else
    formatting_client = clients[1]
  end

  restore_view(function()
    -- Use a long timeout, in case we're using "nix run" and we've just
    -- garbage collected or something
    vim.lsp.buf.format({ id = formatting_client.id, timeout_ms = 30000 })
  end)
end

lspformat()

return lspformat
