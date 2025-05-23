-- Any embedded terminals will use nvr as the default editor
--vim.env.EDITOR = [[nvr --nostart -cc split --remote-wait +"set bufhidden=delete"]]
-- Any embedded terminals will use a neovide popup as default editor
--vim.env.EDITOR =
--  "neovide --geometry 100x60 --wayland-app-id neovide-floating --nofork -- +startinsert"

--vim.env.PATH = vim.env.HOME .. "/.local/share/nvim/mason/bin:" .. vim.env.PATH

local mac_python = "/usr/bin/python3"
--local mac_python = "/Users/tomas/.pyenv/versions/neovim/bin/python"
local nixos_python = "/run/current-system/sw/bin/python3"

vim.g.mapleader = " "

if vim.g.python3_host_prog ~= nil
    and vim.fn.executable(vim.g.python3_host_prog) == 1 then
  -- Already set up properly by system, e.g. on NixOS
elseif vim.fn.executable(mac_python) == 1 then
  vim.g.python3_host_prog = mac_python
elseif vim.fn.executable(nixos_python) == 1 then
  vim.g.python3_host_prog = nixos_python
else
  -- Note: Using a relative path like "python3" will resolve virtualenv
  -- pythons, which will break nvim integration unless the Neovim provider
  -- package is installed there. Use the system Python if possible.
  vim.g.python3_host_prog = "python3"
end

vim.cmd([[au BufRead,BufNewFile ~/.config/nvim/*.lua set foldmethod=marker]])

local init = function(name)
  vim.cmd("runtime init_" .. name .. ".lua")
end

require("hubro.nvimrc").load_local_nvimrc()

vim.cmd("runtime helpers.lua")

init("options")
init("filetypes")
init("keybinds")
init("plugins")
init("gui")
init("custom_commands")
init("autocommands")
init("colorscheme")
init("diagnostics")
