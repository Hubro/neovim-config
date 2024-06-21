return {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  priority = 0,
  config = function()
    local hydra = require("hydra")
    local ts_swap = require("nvim-treesitter.textobjects.swap")
    local ts_move = require("nvim-treesitter.textobjects.move")

    hydra({
      name = "Window resize",
      mode = "n",
      body = "<C-w>",
      heads = {
        { "+", "<C-w>+", {} },
        { "-", "<C-w>-", {} },
        { ">", "<C-w>>", {} },
        { "<", "<C-w><", {} },
      },
      config = {},
    })

    hydra({
      name = "Move class",
      mode = "n",
      body = "<Leader>mc",
      heads = {
        { "j", function() ts_swap.swap_next("@class.outer") end,     {} },
        { "k", function() ts_swap.swap_previous("@class.outer") end, {} },
      },
    })

    hydra({
      name = "Move function",
      mode = "n",
      body = "<Leader>mf",
      heads = {
        { "j", function() ts_swap.swap_next("@function.outer") end,     {} },
        { "k", function() ts_swap.swap_previous("@function.outer") end, {} },
      },
    })

    hydra({
      name = "Move parameter",
      mode = "n",
      body = "<Leader>mp",
      heads = {
        { "j", function() ts_swap.swap_next("@parameter.inner") end,     {} },
        { "k", function() ts_swap.swap_previous("@parameter.inner") end, {} },
        { "l", function() ts_swap.swap_next("@parameter.inner") end,     {} },
        { "h", function() ts_swap.swap_previous("@parameter.inner") end, {} },
      },
    })
  end
}
