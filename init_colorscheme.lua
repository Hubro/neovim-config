vim.g.hubro_current_theme_mode = "light"
vim.g.hubro_default_dark_theme = "catppuccin"
vim.g.hubro_default_light_theme = "dayfox"

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
    -- overrides = {
    --   Normal = {
    --     guibg = "#171717",
    --   },
    --   SignColumn = {
    --     guibg = "#171717",
    --   },
    -- },
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
    colorscheme = "ayu-dark",
    lualine = "ayu_dark",
  },
  ayu_mirage = {
    colorscheme = "ayu-mirage",
    lualine = "ayu_dark",
  },
  ayu_light = {
    colorscheme = "ayu-light",
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
  },
  papercolor = {
    background = "dark",
    colorscheme = "PaperColor",
    lualine = "PaperColor",
  },
  papercolor_light = {
    background = "light",
    colorscheme = "PaperColor",
    lualine = "PaperColor",
  },
  dayfox = {
    background = "light",
    colorscheme = "dayfox",
    lualine = "dayfox",
    before = function()
      soft_setup("nightfox", { options = { dim_inactive = false } })
    end,
    overrides = {
      IndentBlanklineChar = {
        guifd = "#e5ded6",
      },
      IndentBlanklineContextChar = {
        guifg = "#9886c1",
      },
    },
  },
  dawnfox = {
    background = "dark",
    colorscheme = "dawnfox",
    lualine = "dawnfox",
    before = function()
      soft_setup("nightfox", { options = { dim_inactive = false } })
    end,
  },
  duskfox = {
    background = "dark",
    colorscheme = "duskfox",
    lualine = "duskfox",
    before = function()
      soft_setup("nightfox", { options = { dim_inactive = true } })
    end,
  },
  catppuccin = {
    background = "dark",
    colorscheme = "catppuccin-mocha",
    lualine = "auto",
    before = function()
      soft_setup("catppuccin", {
        dim_inactive = { enabled = true },
      })
    end,
    overrides = {
      IndentBlanklineContextChar = {
        guifg = "#ca9374",
        --guifg = "#cba6f7",
      },
      IndentBlanklineContextStart = {
        guisp = "#ca9374",
        --guisp = "#cba6f7",
      },
    },
  },
  catppuccin_light = {
    background = "light",
    colorscheme = "catppuccin-latte",
    lualine = "auto",
  },
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

  if theme.before then
    theme.before()
  end

  vim.cmd("colorscheme " .. theme.colorscheme)

  if theme.overrides then
    for hlgroup_name, hlgroup in pairs(theme.overrides) do
      for hl_name, value in pairs(hlgroup) do
        vim.cmd("highlight " .. hlgroup_name .. " " .. hl_name .. "=" .. value)
      end
    end
  end

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

function _G.toggle_colorscheme()
  if vim.g.hubro_current_theme_mode == "light" then
    vim.g.hubro_current_theme_mode = "dark"
  else
    vim.g.hubro_current_theme_mode = "light"
  end

  if vim.g.hubro_current_theme_mode == "dark" then
    vim.g.hubro_current_theme = vim.g.hubro_default_dark_theme
  else
    vim.g.hubro_current_theme = vim.g.hubro_default_light_theme
  end

  set_default_colorscheme()
end

-- Themes:
--
--   https://github.com/hoob3rt/lualine.nvim/tree/master/lua/lualine/themes
--
function _G.set_lualine_theme(theme)
  require("lualine").setup({
    options = {
      theme = theme,
    },
  })
end

set_default_colorscheme()
