vim.o.completeopt = "menuone,noselect"

-- https://github.com/hrsh7th/nvim-compe#lua-config
require("compe").setup({
  enabled = true,
  autocomplete = true,
  preselect = "enable",
  min_length = 1,

  source = {
    ultisnips = true,
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
  },
})

-- Completion menu ("nvim-compe" plugin)
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-n>", "compe#complete()", { noremap = true, expr = true })
vim.api.nvim_set_keymap(
  "i",
  "<Tab>",
  "compe#confirm({ 'keys': '<Tab>', 'select': v:true })",
  { noremap = true, expr = true }
)
