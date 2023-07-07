vim.wo.colorcolumn = ""
vim.wo.wrap = true
vim.wo.linebreak = true

-- With Markdown, it's often nice to not care about manual line wrapping and
-- let lines overflow instead. These mapping makes soft-wrapped lines easier to
-- navigate.
vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })
vim.keymap.set({ "n", "v" }, "0", "g0", { buffer = true })
vim.keymap.set({ "n", "v" }, "$", "g$", { buffer = true })

-- Some cool extra keybinds for Markdown formatting
vim.keymap.set("v", "<C-b>", "S*gvS*", { buffer = true, remap = true })
vim.keymap.set("v", "<C-i>", "S*", { buffer = true, remap = true })
