return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "ghostbuster91/nvim-next" },
  event = "VeryLazy",
  config = function()
    -- local next_integration = require("nvim-next.integrations").gitsigns

    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
        local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(
          gs.next_hunk,
          gs.prev_hunk
        )

        vim.keymap.set({ "n", "x", "o" }, "]c", next_hunk)
        vim.keymap.set({ "n", "x", "o" }, "[c", prev_hunk)
      end,
    })
  end,
}
