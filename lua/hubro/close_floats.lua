--
-- Closes all non-focused short-lived floating windows
--
-- Should be bound to Esc key to help clear the viewport of distractions such
-- as LSP popups.
--
local close_floats = function()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local success, window_config = pcall(vim.api.nvim_win_get_config, w)

    -- This sometimes fails, I suspect it's because closing one float sometimes
    -- also closes another one, such as the Zen window and its backdrop,
    -- causing the list we're looping over to become outdated part way through.
    if not success then
      goto continue
    end

    local is_floating = window_config.relative ~= ""
    local is_focused = vim.api.nvim_get_current_win() == w

    local buf = vim.api.nvim_win_get_buf(w)
    local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]

    -- Let's not kill borders and scroll bars
    local is_decoration = (
      window_config.width == 1
      or window_config.height == 1
      -- Detects floaterm border:
      or string.find(first_line, "────────────────────")
    )

    -- local is_floaterm_border =

    if is_floating and not is_focused and not is_decoration then
      pcall(vim.api.nvim_win_close, w, false)
    end

    ::continue::
  end
end

return close_floats
