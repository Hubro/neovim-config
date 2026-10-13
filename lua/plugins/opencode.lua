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

    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      auto_insert = false,
      start_insert = true,
      win = {
        title = "OpenCode",
        position = "right",
        enter = true,
        wo = { winbar = "" },
      },
    }

    _G.opencode_paste_operator = function(motion_type)
      local terminal = require('snacks.terminal').get("opencode", {
        create = false,
        count = 1,
      })
      if not terminal then
        vim.notify("Open the OpenCode terminal first", vim.log.levels.WARN)
        return
      end

      local name = vim.api.nvim_buf_get_name(0)
      if name == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
      end

      local path = vim.fn.fnamemodify(name, ':~:.')
      local text = "./" .. path
      if motion_type then
        local first = vim.api.nvim_buf_get_mark(0, "[")[1]
        local last = vim.api.nvim_buf_get_mark(0, "]")[1]
        first, last = math.min(first, last), math.max(first, last)
        local range = first == last and tostring(first) or first .. "-" .. last
        text = text .. ":" .. range
      end
      text = text .. " "
      vim.fn.chansend(vim.b[terminal.buf].terminal_job_id, "\27[200~" .. text .. "\27[201~")
    end

    local function paste_operator()
      vim.o.operatorfunc = "v:lua.opencode_paste_operator"
      return "g@"
    end

    Snacks.keymap.set(
      { "n", "x" }, "<Leader>x",
      function() opencode.select() end,
      { desc = "Execute opencode action…" })

    Snacks.keymap.set(
      { 'n', 't' }, '<C-.>',
      function() require('snacks.terminal').toggle("opencode", snacks_terminal_opts) end,
      { desc = "Toggle OpenCode" })

    Snacks.keymap.set(
      { "n", "x" }, "go",
      paste_operator,
      { desc = "Add range to opencode", expr = true })

    Snacks.keymap.set(
      "n", "goo",
      function() _G.opencode_paste_operator() end,
      { desc = "Add file to opencode" })

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
