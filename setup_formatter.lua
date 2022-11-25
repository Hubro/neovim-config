soft_setup("formatter", {
  filetype = {
    lua = {
      -- This is copied from "formatter.filetypes.lua", but with added options
      function()
        local util = require("formatter.util")

        return {
          exe = "stylua",
          args = {
            "--quote-style=AutoPreferDouble",
            "--indent-type=Spaces",
            "--indent-width=2",
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },

    javascript = {
      require("formatter.filetypes.javascript").prettier,
    },

    python = {
      require("formatter.filetypes.python").isort,
      require("formatter.filetypes.python").black,
    },

    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

-- Automatically format files on save!

local group = vim.api.nvim_create_augroup("formatter.nvim", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  group = group,
  callback = function()
    -- Don't autoformat Python files, it's waaaaaaaay too slow. Use ":Black".
    -- Ref: https://github.com/mhartington/formatter.nvim/issues/213
    if vim.opt.filetype._value == "python" then
      return
    end

    vim.cmd("FormatWrite")
  end,
})

-- Since auto formatting is disabled for Python, explicitly strip whitespace
-- when saving Python files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  group = group,
  command = "FormatWrite sed",
})
