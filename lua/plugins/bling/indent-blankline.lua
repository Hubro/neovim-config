return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = false, -- Config crashes for no reason, try again later
  main = "ibl",
  event = "VeryLazy",
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
