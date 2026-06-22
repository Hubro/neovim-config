return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function()
    local Snacks = require("snacks")
    local opencode = require("opencode")

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    Snacks.keymap.set(
      { "n", "x" }, "<Leader>x",
      function() opencode.select() end,
      { desc = "Execute opencode action…" })

    Snacks.keymap.set(
      { "n", "t" }, "<C-.>",
      function() opencode.toggle() end,
      { desc = "Toggle opencode" })

    Snacks.keymap.set(
      { "n", "x" }, "go",
      function() return opencode.operator("@this ") end,
      { desc = "Add range to opencode", expr = true })

    Snacks.keymap.set(
      "n", "goo",
      function() return opencode.operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    local group = vim.api.nvim_create_augroup("OpenCodeKeybinds", { clear = true })
    vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
      group = group,
      pattern = "term://*:opencode --port",
      callback = function(ev)
        Snacks.keymap.set(
          "n", "<C-u>",
          function() opencode.command("session.half.page.up") end,
          { desc = "Scroll opencode up", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "<C-d>",
          function() opencode.command("session.half.page.down") end,
          { desc = "Scroll opencode down", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "<C-b>",
          function() opencode.command("session.page.up") end,
          { desc = "Scroll opencode up", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "<C-f>",
          function() opencode.command("session.page.down") end,
          { desc = "Scroll opencode down", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "gg",
          function() opencode.command("session.first") end,
          { desc = "Go to first message", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "<C-f>",
          function() opencode.command("session.last") end,
          { desc = "Go to last message", buffer = ev.buf })

        Snacks.keymap.set(
          "n", "<C-f>",
          function() opencode.command("session.last") end,
          { desc = "Go to last message", buffer = ev.buf })

        Snacks.keymap.set(
          { "n", "t" }, "<C-o>",
          function()
            local buf = require("hubro.lib").get_previous_buffer()
            local path = vim.fn.fnamemodify(vim.fn.bufname(buf), ':~:.')
            vim.api.nvim_put({ "./" .. path }, "c", true, true)
          end,
          { desc = "Insert path of active buffer", buffer = ev.buf })
      end,
    })
  end,
}
