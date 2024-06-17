local aug = vim.api.nvim_create_augroup("AutoLoadNvimrc", { clear = true })
vim.api.nvim_create_autocmd("DirChanged", {
  group = aug,
  pattern = "global",
  callback = function()
    require("hubro.nvimrc").load_local_nvimrc()
  end
})
