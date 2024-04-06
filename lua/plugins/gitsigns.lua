return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "ghostbuster91/nvim-next" },
  config = function()
    -- local next_integration = require("nvim-next.integrations").gitsigns

    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        -- local next = next_integration(gs)

        -- vim.keymap.set(
        --   "n",
        --   "]c",
        --   next.next_hunk,
        --   { buffer = bufnr, desc = "Next modified hunk" }
        -- )
        -- vim.keymap.set(
        --   "n",
        --   "[c",
        --   next.prev_hunk,
        --   { buffer = bufnr, desc = "Previous modified hunk" }
        -- )
      end,
    })
  end,
}
