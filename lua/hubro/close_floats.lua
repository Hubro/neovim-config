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
    local bufname = vim.api.nvim_buf_get_name(buf)
    local buflisted = vim.api.nvim_get_option_value("buflisted", { buf = buf })
    local bufhidden = vim.api.nvim_get_option_value("bufhidden", { buf = buf })
    local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]

    -- Don't kill real editor windows
    local is_editor_window = buflisted and bufhidden == ""

    -- Let's not kill borders and scroll bars
    local is_decoration = (
      window_config.width == 1
      or window_config.height == 1
      -- Detects floaterm border:
      or (first_line ~= nil and string.find(first_line, "────────────────────") ~= nil)
    )

    -- Let's not kill backdrops like Zen mode
    local is_backdrop = (
      (math.abs(vim.o.columns - window_config.width) < 5)
      and (math.abs(vim.o.lines - window_config.height) < 5)
    )

    local should_kill = (
      is_floating
      and not is_focused
      and not is_editor_window
      and not is_decoration
      and not is_backdrop
    )

    if should_kill then
      pcall(vim.api.nvim_win_close, w, false)
    end

    ::continue::
  end
end

return close_floats
