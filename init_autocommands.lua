-- Run :checktime at various events, like when the cursor moves
--
-- This makes the "autoread" option work, which reloads buffers if the
-- corresponding file changes on disk.
--
vim.cmd(
  "au FocusGained,BufEnter,CursorHold,CursorHoldI * " .. 'if expand("%f") != "[Command Line]" | checktime | endif'
)

-- Show a warning when a file is reloaded
vim.cmd(
  "autocmd FileChangedShellPost * "
    .. "echohl WarningMsg | "
    .. 'echo "File " . expand("<afile>") . " changed on disk, buffer reloaded" | '
    .. "echohl None"
)

-- function run_checktime(timer_id)
--   vim.cmd[[ checktime ]]
-- end
--
-- -- Run checktime every second
-- vim.fn.timer_start(1000, run_checktime, { ["repeat"] = -1 })

-- Hide line numbers in the gutter in terminal windows
vim.cmd([[au TermOpen * setlocal nonumber | setlocal norelativenumber]])
