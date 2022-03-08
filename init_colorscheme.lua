
vim.g.hubro_current_theme_mode = "dark"
-- vim.g.hubro_default_dark_theme = "one"
-- vim.g.hubro_default_light_theme = "one_light"
-- vim.g.hubro_default_dark_theme = "gruvbox8_hard"
-- vim.g.hubro_default_light_theme = "gruvbox8_hard_light"
vim.g.hubro_default_dark_theme = "dracula"
vim.g.hubro_default_light_theme = "iceberg_light"

if vim.g.hubro_current_theme_mode == "dark" then
  vim.g.hubro_current_theme = vim.g.hubro_default_dark_theme
else
  vim.g.hubro_current_theme = vim.g.hubro_default_light_theme
end

-- Setting a colorscheme before a client is attached to Neovim is apparently
-- pretty buggy, so this workaround waits until the first BufEnter event to set
-- the colorscheme.
--vim.cmd([[
--  aug set_default_colorscheme
--    au BufEnter * ++once lua set_default_colorscheme()
--  aug end
--]])

local themes = {
  gruvbox = {
    background = "dark",
    colorscheme = "gruvbox",
    lualine = "gruvbox",
  },
  gruvbox_light = {
    background = "light",
    colorscheme = "gruvbox",
    lualine = "gruvbox_light",
  },
  gruvbox8_hard = {
    background = "dark",
    colorscheme = "gruvbox8_hard",
    lualine = "gruvbox",
  },
  gruvbox8_hard_light = {
    background = "light",
    colorscheme = "gruvbox8_hard",
    lualine = "gruvbox_light",
  },
  one = {
    background = "dark",
    colorscheme = "one",
    lualine = "onedark",
  },
  one_light = {
    background = "light",
    colorscheme = "one",
    lualine = "onelight",
  },
  iceberg = {
    background = "dark",
    colorscheme = "iceberg",
    lualine = "iceberg_dark",
  },
  iceberg_light = {
    background = "light",
    colorscheme = "iceberg",
    lualine = "iceberg_light",
  },
  ayu = {
    vars = {
      ayucolor = "dark"
    },
    colorscheme = "ayu",
    lualine = "ayu_dark",
  },
  ayu_light = {
    vars = {
      ayucolor = "light"
    },
    colorscheme = "ayu",
    lualine = "ayu_light",
  },
  tokyonight = {
    background = "dark",
    colorscheme = "tokyonight",
    lualine = "auto",
  },
  tokyonight_light = {
    background = "light",
    colorscheme = "tokyonight",
    lualine = "auto",
  },
  dracula = {
    background = "dark",
    colorscheme = "dracula",
    lualine = "dracula",
  }
}

function _G.set_colorscheme(name)
  local theme = themes[name]

  if theme.vars then
    for key, value in pairs(theme.vars) do
      vim.g[key] = value
    end
  end

  if theme.background then
    vim.opt.background = theme.background
  end

  vim.cmd("colorscheme "..theme.colorscheme)

  if theme.lualine then
    set_lualine_theme(theme.lualine)
  else
    set_lualine_theme("auto")
  end

  vim.g.hubro_current_theme = name
end

function _G.set_default_colorscheme()
  local success = pcall(set_colorscheme, vim.g.hubro_current_theme)

  if not success then
    -- Failed to set default colorscheme, no big deal. The required plugins
    -- probably aren't installed.
  end
end

-- Themes:
--
--   https://github.com/hoob3rt/lualine.nvim/tree/master/lua/lualine/themes
--
function _G.set_lualine_theme(theme)
  require"lualine".setup{
    options = {
      theme = theme
    }
  }
end

set_default_colorscheme()
