local splitlines = require "hubro.splitlines"
-- Creates a handy scratch buffer in a new split

local buffer_default_name = "Scratch"
local buffer_name_fmt = "[%s #%s]"
local buffer_counter = {}
local prev_win = {}

BUFFER_OPTIONS = {
  swapfile = false,
  modifiable = false,
  bufhidden = "wipe",
  buflisted = false,
}

local function delete_alt(buf)
  local alt = vim.api.nvim_buf_call(buf, function()
    return vim.fn.bufnr("#")
  end)
  if alt ~= buf and alt ~= -1 then
    pcall(vim.api.nvim_buf_delete, alt, { force = true })
  end
end

local scratch_split = function(opts)
  opts = opts or {}
  opts.split_name = opts.split_name or buffer_default_name
  opts.new_split = opts.new_split or false
  opts.text = opts.text or nil
  -- opts.command = opts.command or nil -- Implement when/if needed

  local win = prev_win[opts.split_name]
  buffer_counter[opts.split_name] = (buffer_counter[opts.split_name] or 0) + 1

  if
      win == nil
      or not vim.api.nvim_win_is_valid(win)
      or opts.new_split == true
  then
    local w = vim.api.nvim_win_get_width(0)
    local h = vim.api.nvim_win_get_height(0)
    local split_command

    if (w / 2) > h then -- Assumes the height of a cell is approx 2x the width
      split_command = "vsplit"
    else
      split_command = "split"
    end

    vim.cmd(split_command)

    win = vim.api.nvim_get_current_win()
    prev_win[opts.split_name] = win
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.api.nvim_buf_set_name(
    buf,
    string.format(buffer_name_fmt, opts.split_name, buffer_counter[opts.split_name])
  )

  if opts.text ~= nil then
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, splitlines(opts.text))
  end

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_buf_delete(buf, { force = true })
  end, { buffer = buf })

  for option, value in pairs(BUFFER_OPTIONS) do
    vim.api.nvim_set_option_value(option, value, { buf = buf })
  end

  return buf
end

return scratch_split
