return {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  priority = 0,
  config = function()
    local hydra = require("hydra")
    local ts_swap = require("nvim-treesitter.textobjects.swap")
    local ts_move = require("nvim-treesitter.textobjects.move")
    local ts_select = require("nvim-treesitter.incremental_selection")

    local ts_select_hydra = hydra({
      name = "Tree-sitter incremental selection",
      mode = "x",
      heads = {
        { "j",     ts_select.node_decremental, { desc = "Decrease selection", mode = "x", } },
        { "k",     ts_select.node_incremental, { desc = "Increase selection", mode = "x", } },
        { "<Esc>", "<Esc>",                    { desc = "Exit", mode = "x", exit_before = true } },
      },
      config = {
        desc = "Tree-sitter incremental selection",
      }
    })

    vim.keymap.set({ "n", "x" }, "<Leader>k", function()
      print("TEST")
      ts_select.init_selection()
      ts_select_hydra:activate()
    end, { desc = "Tree-sitter incremental selection" })

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

    hydra({
      name = "Move statement",
      mode = "n",
      body = "<Leader>ms",
      heads = {
        { "j", function() ts_swap.swap_next("@statement.outer") end,     { desc = "Down" } },
        { "k", function() ts_swap.swap_previous("@statement.outer") end, { desc = "Up" } },
      },
    })
  end
}
