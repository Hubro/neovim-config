local hubrolib = require("hubro.lib")
local is_neovide = (vim.g.neovide == true)

--vim.opt.guifont = "Iosevka Nerd Font:h9.5"
--vim.opt.guifont = "Iosevka Nerd Font:h13:#e-subpixelantialias:#h-full"
--vim.opt.guifont = "CaskaydiaCove Nerd Font Propo:h12"
vim.opt.guicursor = table.concat({
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait1000-blinkoff500-blinkon500-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}, ",")

if vim.fn.has("osx") == 1 then
  -- OSX needs a bigger font
  vim.opt.guifont = "SauceCodePro Nerd Font:h12:w57"
end

if is_neovide then
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_floating_opacity = 0.5
  vim.g.neovide_floating_blur_amount_x = 10
  vim.g.neovide_floating_blur_amount_y = 10
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_smooth_blink = true

  -- Simulate Alacritty (ref: https://neovide.dev/configuration.html#text-gamma-and-contrast)
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_text_gamma = 0.8

  -- Background opacity
  vim.g.neovide_opacity = 0.93

  if vim.api.nvim_exec("echo hostname()", true) == "aura" then
    vim.g.neovide_refresh_rate = 240
  elseif vim.api.nvim_exec("echo hostname()", true) == "cross" then
    vim.g.neovide_refresh_rate = 144
  end

  vim.api.nvim_create_autocmd("UiEnter", {
    once = true,
    callback = function()
      vim.defer_fn(function()
        if hubrolib.workspace_is_empty() then
          require("hubro.session").session_picker()
        end
      end, 50)
    end
  })
end
