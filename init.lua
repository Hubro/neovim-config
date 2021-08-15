
-- Any embedded terminals will use nvr as the default editor
-- vim.env.EDITOR = [[nvr --nostart -cc split --remote-wait +"set bufhidden=delete"]]
-- Any embedded terminals will use a neovide popup as default editor
vim.env.EDITOR = "neovide --geometry 60x40 --wayland-app-id neovide-floating --nofork -- +startinsert"

if vim.fn.has("macunix") == 1 then
    vim.g.python3_host_prog = "/Users/tomas/.pyenv/versions/neovim/bin/python"
    vim.g.mapleader = "+"
else
    vim.g.python3_host_prog = "/home/tomas/.pyenv/versions/neovim/bin/python"
    vim.g.mapleader = "\\"
end

vim.cmd([[au BufRead,BufNewFile ~/.config/nvim/*.lua set foldmethod=marker]])

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
init("custom_commands")
init("autocommands")
init("colorscheme")

if _G.setup_project then
  setup_project()
end
