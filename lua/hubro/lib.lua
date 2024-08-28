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

return M
