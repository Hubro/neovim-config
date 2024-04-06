return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    -- show_current_context_start = true,
    indent = {
      char = "▏",
      -- char = "┊",
      -- char = "▍",
    },
    scope = {
      char = "▎",
      show_start = false,
      show_end = false,
      exclude = {
        language = {
          -- ...
        }
      }
    }
  },
}
