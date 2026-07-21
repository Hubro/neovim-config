local M = {}

-- Feeds all selected lines to a terminal command and replaces the lines with
-- the produced output. Use {} to substitute each line into the command, just
-- find `find`.
M.exec_per_line = function(cmd_template)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local buf = vim.api.nvim_get_current_buf()

  for i = end_line, start_line, -1 do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, true)[1]
    local escaped = vim.fn.shellescape(line)
    local cmd = cmd_template:gsub("{}", escaped)
    local output = vim.fn.systemlist(cmd)

    -- remove trailing empty line that many commands produce
    if #output > 0 and output[#output] == "" then
      table.remove(output)
    end

    vim.api.nvim_buf_set_lines(buf, i - 1, i, true, output)
  end
end

vim.api.nvim_create_user_command("L", function(opts)
  local cmd_template = opts.args
  M.exec_per_line(cmd_template)
end, { range = true, nargs = "+" })

return M
