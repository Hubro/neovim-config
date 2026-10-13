local function setup_opencode_session(opts)
  local Snacks = require("snacks")
  local snacks_terminal = require("snacks.terminal")
  local opencode_terminal = require("hubro.opencode_terminal")
  local restored_terminals = {}
  local win_opts = opencode_terminal.opts.win

  win_opts.bo = { buflisted = true }
  win_opts.on_win = function(terminal)
    -- Snacks closes terminals before AutoSession can save their layout.
    terminal.events = vim.tbl_filter(function(event)
      return event.event ~= "ExitPre"
    end, terminal.events)
  end

  local function terminal_cwd(buf)
    -- Restoring terminal names also creates unlisted alternate-file buffers.
    if not vim.bo[buf].buflisted then
      return
    end
    local cwd = vim.api.nvim_buf_get_name(buf):match("^term://(.*)//%d+:opencode %-%-continue$")
    -- Terminal buffer names shorten the home directory to ~.
    return cwd and vim.fs.normalize(cwd)
  end

  local function restore_terminal(buf)
    if restored_terminals[buf] then
      return restored_terminals[buf]
    end

    vim.fn.bufload(buf)
    local terminal = Snacks.win(Snacks.win.resolve("terminal", win_opts, {
      buf = buf,
      show = false,
      enter = false,
    }))
    terminal:open_buf()
    restored_terminals[buf] = terminal

    local win = vim.fn.win_findbuf(buf)[1]
    if win then
      -- Attach to the restored split without starting a second OpenCode process.
      terminal.opts.position = "current"
      vim.api.nvim_win_call(win, function() terminal:show() end)
      terminal.opts.position = "right"
    end
    return terminal
  end

  local get_terminal = opencode_terminal.get
  opencode_terminal.get = function(create)
    local terminal = get_terminal(false)
    if terminal and terminal:buf_valid() then
      return terminal, false
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if terminal_cwd(buf) == vim.fn.getcwd() then
        return restore_terminal(buf), false
      end
    end
    if create then
      return get_terminal(true)
    end
  end

  opts.pre_restore_cmds = opts.pre_restore_cmds or {}
  table.insert(opts.pre_restore_cmds, function()
    -- Detach Snacks before AutoSession replaces the buffers in its windows.
    for _, terminal in ipairs(snacks_terminal.list()) do
      if terminal.cmd == opencode_terminal.command then
        terminal:hide()
      end
    end
    for _, terminal in pairs(restored_terminals) do
      terminal:hide()
    end
  end)

  local group = vim.api.nvim_create_augroup("AutoSessionOpenCode", { clear = true })
  vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = group,
    nested = true,
    callback = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if terminal_cwd(buf) then
          restore_terminal(buf)
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(ev)
      local terminal = restored_terminals[ev.buf]
      if terminal and vim.v.event.status == 0 then
        terminal:close()
        vim.api.nvim_buf_delete(ev.buf, { force = true })
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      local terminal = restored_terminals[ev.buf]
      if terminal then
        restored_terminals[ev.buf] = nil
        vim.schedule(function() terminal:close() end)
      end
    end,
  })
end

return {
  "rmagatti/auto-session",
  dependencies = {
    "folke/snacks.nvim"
  },
  lazy = false,
  init = function()
    -- ...
  end,
  opts = {
    auto_save = true,
    auto_create = true,
    auto_restore = true,
    auto_delete_empty_sessions = false,
    suppressed_dirs = { "/home", "/home/tomas", "/home/tomas/Desktop", "/home/tomas/bin" },
    pre_save_cmds = {
      function()
        require("hubro.close_floats")()
        require("notify").dismiss({})
      end
    },
    post_restore_cmds = {
      function()
        -- ...
      end
    },
    -- I'm using my own, much superior picker (see hubro.session)
    -- session_lens = {
    --   load_on_setup = true,
    -- },
  },
  config = function(_, opts)
    setup_opencode_session(opts)
    require("auto-session").setup(opts)
  end
}
