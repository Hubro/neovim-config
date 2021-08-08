
if vim.g.neovide then
  vim.opt.guifont = "Source Code Pro:h9"
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.2

  if vim.api.nvim_exec("echo hostname()", true) == "aura" then
      vim.g.neovide_refresh_rate=240
  else
      vim.g.neovide_refresh_rate=60
  end
end
