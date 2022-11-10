soft_setup("formatter", {
  filetype = {
    lua = {
      -- require("formatter.filetypes.lua").stylua,
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

    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

-- Always run :Format on every file write. This shouldn't do anything on
-- filetypes the formatter isn't configured for, so it should be safe (fingers
-- crossed.)
local group = vim.api.nvim_create_augroup("formatter.nvim", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  group = group,
  command = "FormatWrite",
})
