local soft_setup = require("hubro.soft_setup")

-- Returns the name of the current theme mode (dark or light)
local function current_theme_mode()
  if vim.g.hubro_current_theme_mode ~= nil then
    return vim.g.hubro_current_theme_mode
  end

  local current_mode

  if vim.fn.executable("darkman") == 1 then
    -- Dark mode detection on Linux with Sway/Hyprland
    local result = vim.trim(vim.fn.system({ "darkman", "get" }))
    current_mode = vim.trim(result)
  elseif vim.fn.executable("osascript") == 1 then
    -- Dark mode detection on MacOS
    local result = vim.trim(vim.fn.system({
      "osascript",
      "-e",
      'tell application "System Events" to tell appearance preferences to return dark mode',
    }))
    current_mode = result == "true" and "dark" or "light"
  else
    -- Defaults to dark otherwise
    current_mode = "dark"
  end

  vim.g.hubro_current_theme_mode = current_mode
  return current_mode
end

vim.g.hubro_default_dark_theme = "catppuccin"
vim.g.hubro_default_light_theme = "dayfox"

if current_theme_mode() == "dark" then
  vim.g.hubro_current_theme = vim.g.hubro_default_dark_theme
else
  vim.g.hubro_current_theme = vim.g.hubro_default_light_theme
end

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
        guifg = "#e5ded6",
        gui = "nocombine", -- https://github.com/lukas-reineke/indent-blankline.nvim/discussions/569
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
    colorscheme = "catppuccin-mocha",
    lualine = "auto",
    before = function()
      soft_setup("catppuccin", {
        dim_inactive = { enabled = true },
        -- transparent_background = true,
      })
    end,
    overrides = {
      IndentBlanklineContextChar = {
        guifg = "#ca9374",
        gui = "nocombine", -- https://github.com/lukas-reineke/indent-blankline.nvim/discussions/569
        --guifg = "#cba6f7",
      },
      IndentBlanklineContextStart = {
        guisp = "#ca9374",
        --guisp = "#cba6f7",
      },
      TreesitterContext = {
        guibg = "#3a3a4b",
      },
    },
  },
  catppuccin_light = {
    colorscheme = "catppuccin-latte",
    lualine = "auto",
    before = function()
      soft_setup("catppuccin", {
        dim_inactive = { enabled = true },
      })
    end,
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
    -- No big deal, the required plugins probably aren't installed.
    vim.notify(
      "Failed to set colorscheme to " .. vim.g.hubro_current_theme,
      vim.log.levels.WARN
    )
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

--
-- Set default colorscheme on startup
--

local augroup =
  vim.api.nvim_create_augroup("SetDefaultColorscheme", { clear = true })

vim.api.nvim_create_autocmd("UIEnter", {
  group = augroup,
  callback = function(env)
    set_default_colorscheme()
  end,
})
