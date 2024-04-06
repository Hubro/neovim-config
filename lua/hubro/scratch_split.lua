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

local _set_defaults = function(opts)
  local opts = opts or {}

  local set_default = function(name, value)
    if opts[name] == nil then
      opts[name] = value
    end
  end

  set_default("split_name", buffer_default_name)
  set_default("new_split", false)
  set_default("text", nil)
  set_default("filetype", nil)
  set_default("focus", true)
  -- set_default("command", nil)  -- Implement when/if needed

  return opts
end

local scratch_split = function(opts)
  opts = _set_defaults(opts)

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
      split_command = "noa vsplit"
    else
      split_command = "noa split"
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

  if opts.filetype ~= nil then
    vim.api.nvim_set_option_value("filetype", opts.filetype, { buf = buf })
  end

  for option, value in pairs(BUFFER_OPTIONS) do
    vim.api.nvim_set_option_value(option, value, { buf = buf })
  end

  if not opts.focus then
    vim.cmd("noa wincmd p")
  end

  return buf
end

return scratch_split
