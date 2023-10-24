-- local augroup = vim.api.nvim_create_augroup("SetGUISettings", { clear = true })

-- local function write(text)
--   local lines = {}

--   for s in text:gmatch("[^\n]+") do
--     table.insert(lines, s)
--   end

--   table.insert(lines, "")

--   vim.api.nvim_buf_set_lines(0, -1, -1, true, lines)
-- end

-- vim.api.nvim_create_autocmd("UIEnter", {
--   group = augroup,
--   callback = function(env)
--     write("Got UIEnter Event:" .. vim.inspect(env))
--     write(vim.inspect(vim.g.neovide))
--   end,
-- })

local is_neovide = (vim.g.neovide == true)

-- vim.g.hubro_default_font = "Iosevka Nerd Font:h9.5"
-- vim.g.hubro_big_font = "Iosevka Nerd Font:h13.5"
-- vim.g.hubro_huge_font = "Iosevka Nerd Font:h18"
vim.g.hubro_default_font = "CaskaydiaCove NF Regular:h9.5"
vim.g.hubro_big_font = "CaskaydiaCove NF Regular:h13.0"
vim.g.hubro_huge_font = "CaskaydiaCove NF Regular:h18"

-- vim.opt.guifont = "SauceCodePro Nerd Font:h9"
-- vim.opt.guifont = "SauceCodePro Nerd Font:h9:w57"

vim.opt.guifont = vim.g.hubro_default_font

if vim.fn.has("osx") == 1 then
  -- OSX needs a bigger font
  vim.opt.guifont = "SauceCodePro Nerd Font:h12:w57"
end

if is_neovide then
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_floating_opacity = 0.5
  vim.g.neovide_floating_blur_amount_x = 10
  vim.g.neovide_floating_blur_amount_y = 10

  -- Background transparency
  vim.g.neovide_transparency = 1.0
  -- vim.g.neovide_transparency = 0.97

  if vim.api.nvim_exec("echo hostname()", true) == "aura" then
    vim.g.neovide_refresh_rate = 240
  elseif vim.api.nvim_exec("echo hostname()", true) == "cross" then
    vim.g.neovide_refresh_rate = 144
    vim.g.hubro_default_font = "CaskaydiaCove NF Regular:h13.0"
    vim.g.hubro_big_font = "CaskaydiaCove NF Regular:h13.0"
    vim.g.hubro_huge_font = "CaskaydiaCove NF Regular:h13.0"
    vim.opt.guifont = vim.g.hubro_default_font
  else
    vim.g.neovide_refresh_rate = 60
  end
end
