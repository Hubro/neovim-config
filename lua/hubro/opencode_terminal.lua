local M = {
  command = "opencode --continue",
  ---@type snacks.terminal.Opts
  opts = {
    count = 1,
    auto_insert = false,
    start_insert = true,
    win = {
      title = "OpenCode",
      position = "right",
      enter = true,
      wo = { winbar = "" },
    },
  },
}

function M.get(create)
  return require("snacks.terminal").get(M.command, vim.tbl_extend("force", M.opts, { create = create }))
end

function M.toggle()
  local terminal, created = M.get(true)
  local opencode_in_focus = vim.api.nvim_get_current_win() == terminal.win and vim.fn.mode() == "t"

  if not created and opencode_in_focus then
    terminal:hide()
  else
    terminal:show():focus()
    vim.cmd.startinsert()
  end
end

function M.paste(motion_type)
  local terminal = M.get(false)
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

function M.paste_operator()
  vim.o.operatorfunc = "v:lua.require'hubro.opencode_terminal'.paste"
  return "g@"
end

---Lets left click work in opencode even when not already in terminal mode
function M.focus_and_click()
  local mouse = vim.fn.getmousepos()

  if mouse.winid ~= 0 and mouse.line > 0 then
    local buf = vim.api.nvim_win_get_buf(mouse.winid)
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.bo[buf].buftype == "terminal"
        and (name:match(":opencode$") or name:match(":opencode %-%-continue$")) then
      -- Replay the click in terminal mode so OpenCode receives it.
      return "<Esc><LeftMouse>i<LeftMouse>"
    end
  end

  return "<LeftMouse>"
end

function M.insert_previous_buffer_path()
  local buf = require("hubro.lib").get_previous_buffer()
  local path = vim.fn.fnamemodify(vim.fn.bufname(buf), ':~:.')
  vim.api.nvim_put({ "./" .. path }, "c", true, true)
end

return M
