return {
  "github/copilot.vim",
  enabled = true,
  cmd = { "Copilot" },
  keys = { "<A-p>", "<Leader>cp" },
  init = function()
    -- Keep copilot disabled, only invoke explicitly
    vim.g.copilot_filetypes = { ["*"] = false }
    vim.g.copilot_no_tab_map = true

    -- Once it's started, it's started. There's probably never a point in
    -- checking more than once.
    local copilot_lsp_started = false

    local suggest = function()
      if not copilot_lsp_started then
        local clients = vim.tbl_map(
          function(client) return client.name end,
          vim.lsp.get_clients()
        )

        if not vim.tbl_contains(clients, "GitHub Copilot") then
          vim.notify("Starting GitHub Copilot LSP", "info", { title = "GitHub Copilot" })
          vim.cmd("silent Copilot restart")
        end

        copilot_lsp_started = true
      end

      -- require("cmp").abort() -- Hide cmp completion window
      vim.fn["copilot#Suggest"]()
    end

    local accept = function()
      -- require("cmp").abort() -- Hide cmp completion window
      return vim.fn["copilot#Accept"]()
    end

    local accept_word = function()
      vim.schedule(suggest)
      return vim.fn["copilot#AcceptWord"]()
    end

    local accept_line = function()
      vim.schedule(suggest)
      return vim.fn["copilot#AcceptLine"]()
    end

    vim.keymap.set("i", "<A-p>", suggest, { silent = true })
    vim.keymap.set("i", "<C-e>", accept, { expr = true, replace_keycodes = false })
    vim.keymap.set("i", "<A-l>", accept_word, { expr = true, remap = true, replace_keycodes = true })
    vim.keymap.set("i", "<A-L>", accept_line, { expr = true, remap = true, replace_keycodes = true })
    vim.keymap.set("n", "<Leader>cp", ":Copilot panel<CR>", { silent = true })
    vim.keymap.set("i", "<A-j>", "<Plug>(copilot-next)", { silent = true })
    vim.keymap.set("i", "<A-k>", "<Plug>(copilot-previous)", { silent = true })
  end,
}
