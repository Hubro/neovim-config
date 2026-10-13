return {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  priority = 0,
  config = function()
    local hydra = require("hydra")
    local ts_swap = require("nvim-treesitter-textobjects.swap")

    local ts_select_hydra = hydra({
      name = "Tree-sitter incremental selection",
      mode = "x",
      heads = {
        { "j",     function() vim.cmd.normal("in") end, { desc = "Decrease selection", mode = "x", } },
        { "k",     function() vim.cmd.normal("an") end, { desc = "Increase selection", mode = "x", } },
        { "<Esc>", "<Esc>", { desc = "Exit", mode = "x", exit_before = true } },
      },
      config = {
        desc = "Tree-sitter incremental selection",
      }
    })

    vim.keymap.set({ "n", "x" }, "<Leader>k", function()
      vim.cmd.normal("van")
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
