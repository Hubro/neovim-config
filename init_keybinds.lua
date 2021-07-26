
local default_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<BS>", ":nohl<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<Space>", "za", default_opts)

-- Easier window navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", default_opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", default_opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", default_opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", default_opts)

-- Show FZF!
vim.api.nvim_set_keymap("n", "<C-p>", ":FZF<CR>", default_opts)

-- Toggle file tree (nvim-tree.lua)
vim.api.nvim_set_keymap("n", "<Leader>t", ":NvimTreeToggle<CR>", default_opts)

-- Show completion menu ("compe" plugin)
vim.api.nvim_set_keymap("i", "<C-n>", "compe#complete()", {noremap = true, expr = true})

-- Show diagnostics window ("trouble.nvim" plugin)
vim.api.nvim_set_keymap("n", "<Leader>d", ":Trouble<CR>", default_opts)

-- Floating terminal ("vim-floaterm" plugin)
vim.api.nvim_set_keymap("n", "<C-q>", ":FloatermToggle quick<CR>", default_opts)
vim.api.nvim_set_keymap("t", "<C-q>", "<C-\\><C-n>:FloatermToggle quick<CR>", default_opts)

-- Open a new embedded terminal in a split
vim.api.nvim_set_keymap("n", "<F1>", ":vsplit<CR>:terminal<CR>i", default_opts)
vim.api.nvim_set_keymap("n", "<S-F1>", ":split<CR>:terminal<CR>i", default_opts)

-- Wrap the current line while in insert mode
vim.api.nvim_set_keymap("i", "<M-q>", "<Esc>gqq0A", default_opts)


-- CTRL+Enter creates a new line below the current line, Shift+Enter creates a
-- line above the current line.
vim.api.nvim_set_keymap("i", "<C-CR>", "<Esc>o", default_opts)
vim.api.nvim_set_keymap("i", "<S-CR>", "<Esc><S-o>", default_opts)
