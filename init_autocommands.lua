-- Run :checktime at various events, like when the cursor moves
--
-- This makes the "autoread" option work, which reloads buffers if the
-- corresponding file changes on disk.
--
vim.cmd(
  "au FocusGained,BufEnter,CursorHold,CursorHoldI * "
  .. 'if expand("%f") != "[Command Line]" | checktime | endif'
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

-- Temporarily highlight yanked text
vim.cmd([[
  augroup highlight_yank
    au!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  augroup END
]])

-- Auto-format on save using LSP
local auto_format_filetypes = { "astro", "rust", "svelte", "nix", "lua" }
local auto_format_aug = vim.api.nvim_create_augroup("AutoFormatWithLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = auto_format_aug,
  callback = function()
    for _, filetype in ipairs(auto_format_filetypes) do
      if filetype == vim.o.filetype then
        require("hubro.lspformat")()
      end
    end
  end
})

-- Refresh neo-tree Git status
--
-- This should be happening automatically but appears to have been broken for a while.
-- Ref: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/724
--
local refresh_neotree_aug = vim.api.nvim_create_augroup("RefreshNeoTree", { clear = true })
local refresh_neotree_git_status = function()
  pcall(function()
    require("neo-tree.sources.git_status").refresh()
  end)
end
vim.api.nvim_create_autocmd("TabEnter", {
  group = refresh_neotree_aug,
  callback = refresh_neotree_git_status,
})

-- Execute every Lua file under ./autocommands/
local au_dir = vim.fn.expand(vim.fn.stdpath("config") .. "/autocommands")
local au_files = vim.fn.glob(au_dir .. "/*.lua", false, true)
for _, file in ipairs(au_files) do
  vim.cmd("luafile " .. file)
end
