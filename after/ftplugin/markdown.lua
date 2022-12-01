vim.wo.colorcolumn = "121"
vim.bo.textwidth = 120

-- Some cool extra keybinds for Markdown formatting
vim.keymap.set("v", "<C-b>", "S*gvS*", { buffer = true, remap = true })
vim.keymap.set("v", "<C-i>", "S*", { buffer = true, remap = true })
