return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "ghostbuster91/nvim-next" },
  event = "VeryLazy",
  config = function()
    require("gitsigns").setup({
      on_attach = function()
        local gs = require("gitsigns")
        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
        local hunk = ts_repeat_move.make_repeatable_move(function(opts)
          if opts.forward then
            gs.nav_hunk("next")
          else
            gs.nav_hunk("prev")
          end
        end)
        -- local next_hunk = ts_repeat_move.make_repeatable_move(function() gs.nav_hunk("next") end)
        -- local prev_hunk = ts_repeat_move.make_repeatable_move(function() gs.nav_hunk("prev") end)

        vim.keymap.set({ "n", "x", "o" }, "]c", function() hunk({ forward = true }) end)
        vim.keymap.set({ "n", "x", "o" }, "[c", function() hunk({ forward = false }) end)
      end,
    })
  end,
}
