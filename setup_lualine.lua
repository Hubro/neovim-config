local success, lualine = pcall(require, "lualine")

-- Don't bother crashing loudly if lualine isn't installed
if success then
  -- local tabline = require("tabline")
  local lsp_status = require("lsp-status")
  local gps = require("nvim-gps")

  -- tabline.setup { enable = false }

  lsp_status.config({
    diagnostics = false,
    current_function = false,
    status_symbol = "LSP ✓",
  })

  gps.setup({
    icons = {
      ["class-name"] = "☰ ", -- Classes and class-like objects
      ["function-name"] = "λ ", -- Functions
      ["method-name"] = " ", -- Methods
    },
    -- separator = " ➜  ",
    -- separator = " / ",
    separator = "  ",
  })

  lualine.setup({
    options = {
      disabled_filetypes = { "NvimTree", "minimap" },
    },
    extensions = { "fugitive", "nvim-tree", "quickfix" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename" },
      lualine_c = { { gps.get_location, cond = gps.is_available } },

      lualine_x = {},
      lualine_y = {
        function()
          return lsp_status.status()
        end,
        "filetype",
      },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },

      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = {},
      lualine_b = {
        "branch",
      },
      lualine_c = {
        {
          "filename",
          path = 1, -- Show relative path, not just filename
          separator = "",
        },
        { gps.get_location, cond = gps.is_available },
      },

      -- lualine_x = { tabline.tabline_tabs },
      lualine_x = {
        {
          "tabs",
          tabs_color = {
            active = "lualine_a_normal",
            inactive = "lualine_b_normal",
          },
        },
      },
      lualine_y = {},
      lualine_z = {},
    },
  })

  -- Redraw tabline every time the cursor moves
  vim.cmd([[
    aug update_tabline
      au!
      au CursorMoved * redrawtabline
    aug END
  ]])
end
