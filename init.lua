
-- Any embedded terminals will use nvr as the default editor
-- vim.env.EDITOR = [[nvr --nostart -cc split --remote-wait +"set bufhidden=delete"]]
-- Any embedded terminals will use a neovide popup as default editor
vim.env.EDITOR = "neovide --geometry 100x60 --wayland-app-id neovide-floating --nofork -- +startinsert"

if vim.fn.has("macunix") == 1 then
    vim.g.python3_host_prog = "/Users/tomas/.pyenv/versions/neovim/bin/python"
    vim.g.mapleader = "+"
else
    vim.g.python3_host_prog = "/home/tomas/.pyenv/versions/neovim/bin/python"
    vim.g.mapleader = "\\"
end

vim.cmd([[au BufRead,BufNewFile ~/.config/nvim/*.lua set foldmethod=marker]])

local init = function (name)
    vim.cmd("runtime init_" .. name .. ".lua")
end

-- Source local .nvimrc here if present (DEPRECATE THIS IN FAVOR OF LUA INIT)
if vim.fn.filereadable(".nvimrc") == 1 then
  vim.cmd("source .nvimrc")
end

-- Source local project-specific config here
if vim.fn.filereadable(".nvimrc.lua") == 1 then
  vim.cmd("source .nvimrc.lua")
end

vim.cmd("runtime helpers.lua")

init("options")
init("keybinds")
-- init("packer")
init("plugins")
init("gui")
init("custom_commands")
init("autocommands")
init("colorscheme")

-- DEPRECATE THIS IN FAVOR OF LUA POST INIT (see below)
if _G.setup_project then
  _G.setup_project()
end

-- Source local project-specific post config here
if vim.fn.filereadable(".nvimrc-post.lua") == 1 then
  vim.cmd("source .nvimrc-post.lua")
end
