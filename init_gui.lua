local is_neovide = (vim.g.neovide == true)

--vim.opt.guifont = "Iosevka Nerd Font:h9.5"
vim.opt.guifont = "Iosevka Nerd Font"

if vim.fn.has("osx") == 1 then
  -- OSX needs a bigger font
  vim.opt.guifont = "SauceCodePro Nerd Font:h12:w57"
end

if is_neovide then
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_floating_opacity = 0.5
  vim.g.neovide_floating_blur_amount_x = 10
  vim.g.neovide_floating_blur_amount_y = 10

  -- Background transparency
  vim.g.neovide_transparency = 0.93

  if vim.api.nvim_exec("echo hostname()", true) == "aura" then
    vim.g.neovide_refresh_rate = 240
  elseif vim.api.nvim_exec("echo hostname()", true) == "cross" then
    vim.g.neovide_refresh_rate = 144
    vim.opt.guifont = "Iosevka Nerd Font"
  end
end
