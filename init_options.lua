vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hidden = true         -- Allow unsaved background buffers
vim.opt.termguicolors = true  -- Allow true colors in color schemes
vim.opt.updatetime = 100      -- To make gitgutter update faster
vim.opt.scrolloff = 5         -- Keep 5 lines margin between cursor and edge
vim.opt.mouse = "a"           -- Enable mouse, mostly useful for resizing
vim.opt.foldmethod = "marker" -- Enable marker folding by default
vim.opt.signcolumn = "yes"    -- Always show sign column, prevents jumping
vim.opt.indentkeys = nil
vim.opt.shortmess:append("I") -- Disable intro message

-- The "behave" command suddenly disappeared in Neovim 0.10.0
vim.opt.mousemodel = "extend"

-- Default whitespace settings. These will probably be overridden by file type
-- specific settings or EditorConfig.
vim.opt.tabstop = 8      -- Show literal tab symbols as 8 spaces
vim.opt.expandtab = true -- Insert spaces rather than literal tab symbols
vim.opt.shiftwidth = 4   -- Spaces to use for auto-indent, >> and <<
vim.opt.softtabstop = 4  -- Insert 4 spaces when pressing tab or backspace

--vim.opt.colorcolumn = { 80 }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- When saving sessions, don't save settings. Usually the reason I restart vim
-- is to reload settings.
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "help",
  "resize",
  "tabpages",
  "terminal",
  "winpos",
  "winsize",

  --   auto-session ERROR: Error restoring session! The session might be corrupted.
  -- Disabling auto save. Please check for errors in your config. Error:
  -- vim/_editor.lua:0: nvim_exec2()../home/tomas/.local/share/nvim/sessions/%home%to
  -- omas%Dropbox%Telia%src%github%nso.vim, line 214: Vim(normal):E490: No fold found
  -- d
  -- "folds",
}
