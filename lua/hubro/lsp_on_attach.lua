local efm_on_attach = function(client, bufnr)
  local efm_ns = vim.lsp.diagnostic.get_namespace(client.id)

  local augroup = vim.api.nvim_create_augroup("efm-clear-diagnostics-buf-" .. bufnr, {})

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    buffer = bufnr,
    desc = "Clears diagnostics from efm-langserver when the document changes",
    callback = function()
      local diagnostics = vim.diagnostic.get(bufnr, { namespace = efm_ns })
      local filteredDiagnostics = {}

      for _, diag in ipairs(diagnostics) do
        if diag.source ~= "mypy" then
          table.insert(filteredDiagnostics, diag)
        end
      end

      vim.diagnostic.set(efm_ns, bufnr, filteredDiagnostics, {})
    end
  })
end

--
-- Handler for when a buffer is connected to a language server
--
---@param client vim.lsp.Client
---@param bufnr number
return function(client, bufnr)
  local navic = require("nvim-navic")

  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  -- For Python, only run setup for basedpyright
  if filetype == "python" and client.name ~= "basedpyright" then
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- The Ruff LSP only provides diagnostics, let's not set any key bindings
  if client.name == "ruff" then
    return
  end

  if client.name == "efm" then
    efm_on_attach(client, bufnr)
  end

  local function map(mode, lh, rh)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, lh, rh, opts)
  end

  -- Use nvim-next to hop to diagnostic, which makes it a repeatable motion
  -- local next_lspdiag = require("nvim-next.integrations.diagnostic")()

  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", "gr", "<cmd>Trouble lsp_references<CR>")
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "L", "<cmd>lua vim.diagnostic.open_float()<CR>")
  map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", "<Leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", "<Leader>lA", "<cmd>lua vim.lsp.buf.code_action({ apply=true })<CR>")

  map("n", "<Leader>lr", function()
    local rename_opts = {}

    if filetype == "python" then
      rename_opts["name"] = "basedpyright"
    end

    vim.lsp.buf.rename(nil, rename_opts)
  end)

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  local next_diag, prev_diag = ts_repeat_move.make_repeatable_move_pair(
    function() vim.diagnostic.jump({ count = 1, float = true }) end,
    function() vim.diagnostic.jump({ count = -1, float = true }) end
  )

  map({ "n", "x", "o" }, "]d", next_diag)
  map({ "n", "x", "o" }, "[d", prev_diag)
end
