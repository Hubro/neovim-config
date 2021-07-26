
-- Any embedded terminals will use nvr as the default editor
vim.env.EDITOR = [[nvr --nostart -cc split --remote-wait +"set bufhidden=delete"]]

vim.g.python3_host_prog = "/home/tomas/.pyenv/versions/neovim/bin/python"

-- Run :checktime any time the cursor moves
--
-- This makes the "autoread" option work, which reloads buffers if the
-- corresponding file changes on disk.
--
vim.cmd([[au CursorHold * checktime]])

-- Hide line numbers in the gutter in terminal windows
vim.cmd([[au TermOpen * setlocal nonumber | setlocal norelativenumber]])

function init(name)
    vim.cmd("runtime init_" .. name .. ".lua")
end

-- Source local .nvimrc here if present
if vim.fn.filereadable(".nvimrc") == 1 then
  vim.cmd("source .nvimrc")
end

init("options")
init("keybinds")
init("packer")
init("plugins")
init("gui")

-- Default color scheme
vim.cmd [[
  try
    colorscheme gruvbox
  catch
    " Guess it's not installed
  endtry
]]
