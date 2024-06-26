local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

function setup_file(name)
  return function()
    vim.cmd("runtime setup_" .. name .. ".lua")
  end
end

require("lazy").setup("plugins", {
  dev = {
    path = "~/projects",
    pattern = { "Hubro" },
    fallback = true,
  },
})
