return {
  "github/copilot.vim",
  event = "VeryLazy",
  init = function()
    -- Keep copilot disabled, only invoke explicitly
    vim.g.copilot_filetypes = { ["*"] = false }
    vim.g.copilot_no_tab_map = true

    local suggest = function()
      require("cmp").abort() -- Hide cmp completion window
      vim.fn["copilot#Suggest"]()
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
    vim.keymap.set("i", "<C-e>", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
    vim.keymap.set("i", "<A-l>", accept_word, { expr = true, remap = true, replace_keycodes = true })
    vim.keymap.set("i", "<A-h>", accept_line, { expr = true, remap = true, replace_keycodes = true })
    vim.keymap.set("n", "<Leader>cp", ":Copilot panel<CR>", { silent = true })
    vim.keymap.set("i", "<A-j>", "<Plug>(copilot-next)", { silent = true })
    vim.keymap.set(
      "i",
      "<A-k>",
      "<Plug>(copilot-previous)",
      { silent = true }
    )
  end,
}
