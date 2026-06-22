M = {}

---Returns true if the cwd is inside a Git repository
---@return boolean
M.in_repo = function()
  local result = vim.system(
    { "git", "rev-parse", "--is-inside-work-tree" },
    { text = true }
  ):wait()

  return result.code == 0 and vim.trim(result.stdout) == "true"
end

---Buffer type
---@class Buffer
---@field bufnr number
---@field name string
---@field modified boolean

M.buffers = function()
  ---@type Buffer[]
  local buffers = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) == true then
      ---@type Buffer
      local buffer = {
        bufnr = bufnr,
        name = vim.api.nvim_buf_get_name(bufnr),
        modified = vim.api.nvim_get_option_value("modified", { buf = bufnr }),
      }
      table.insert(buffers, buffer)
    end
  end

  return buffers
end

M.workspace_is_empty = function()
  local buffers = M.buffers()

  return (
    #buffers == 1
    and buffers[1].name == ""
    and not buffers[1].modified
  )
end

-- Returns the directory of the buffer as a nice relative path
M.buf_dir = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Remove leading protocol (e.g. "oil://") if any
  filepath = string.gsub(filepath, "^%a+://", "")

  local is_dir = vim.fn.isdirectory(filepath) == 1
  local path

  if is_dir then
    path = filepath
  else
    path = vim.fn.fnamemodify(filepath, ":h")
  end

  -- Make path absolute (not sure if this is necessary, seems to always be
  -- absolute anyway)
  path = vim.fn.fnamemodify(path, ":p")

  -- Makes the path relative to CWD if possible. Otherwise makes it relative to
  -- "~/" if possible. Otherwise does nothing.
  path = vim.fn.fnamemodify(path, ":~:.")

  if path == "" then
    path = "./" -- This is more clear than an empty string
  end

  return path
end

-- Returns a list of buffer IDs in the order they were last visited
M.get_recent_buffers = function()
  local current_buf = vim.api.nvim_get_current_buf()
  local jumplist, current_idx = unpack(vim.fn.getjumplist())
  local seen = { [current_buf] = true } -- Don't include the current buffer in the output
  local bufs = {}

  -- Walk backwards from current position for most-recent-first order
  for i = current_idx, 1, -1 do
    local buf = jumplist[i].bufnr

    if not seen[buf] and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      seen[buf] = true
      bufs[#bufs + 1] = buf
    end
  end

  return bufs
end

-- Returns the previously focused buffer, regardless of window or tab
M.get_previous_buffer = function()
  -- Previous window in current tab?
  if vim.fn.winnr("$") > 1 then
    local win = vim.fn.win_getid(vim.fn.winnr("#"))
    if win ~= 0 and win ~= vim.api.nvim_get_current_win() then
      return vim.api.nvim_win_get_buf(win)
    end
  end

  if vim.fn.tabpagenr("$") > 1 then
    local tnr = vim.fn.tabpagenr("#")

    if tnr == 0 then
      error("no previous tab")
    end

    local tab = vim.api.nvim_list_tabpages()[tnr]
    local win = vim.api.nvim_tabpage_get_win(tab)

    return vim.api.nvim_win_get_buf(win)
  end

  error("only one tab and one window")
end

return M
