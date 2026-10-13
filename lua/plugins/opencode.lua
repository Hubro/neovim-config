return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function()
    local Snacks = require("snacks")
    local opencode = require("opencode")
    local opencode_terminal = require("hubro.opencode_terminal")

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    Snacks.keymap.set(
      { "n", "x" }, "<Leader>x",
      function() opencode.select() end,
      { desc = "Execute opencode action…" })

    Snacks.keymap.set(
      { 'n', 't' }, '<C-.>',
      opencode_terminal.toggle,
      { desc = "Toggle OpenCode" })

    Snacks.keymap.set(
      { "n", "x" }, "go",
      opencode_terminal.paste_operator,
      { desc = "Add range to opencode", expr = true })

    Snacks.keymap.set(
      "n", "goo",
      opencode_terminal.paste,
      { desc = "Add file to opencode" })

    Snacks.keymap.set(
      { "n", "x" }, "<LeftMouse>",
      opencode_terminal.focus_and_click,
      { desc = "Focus and click OpenCode", expr = true })

    local group = vim.api.nvim_create_augroup("OpenCodeKeybinds", { clear = true })
    vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
      group = group,
      pattern = { "term://*:opencode", "term://*:opencode --continue" },
      callback = function(ev)
        Snacks.keymap.set(
          "t", "<C-h>",
          "<C-\\><C-n><C-w>h",
          { desc = "Focus window to the left", buffer = ev.buf })

        Snacks.keymap.set(
          "t", "<C-l>",
          "<C-\\><C-n><C-w>l",
          { desc = "Focus window to the right", buffer = ev.buf })

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
          opencode_terminal.insert_previous_buffer_path,
          { desc = "Insert path of active buffer", buffer = ev.buf })
      end,
    })
  end,
}
