local soft_require = require("hubro.soft_require")

local default_opts = { noremap = true, silent = true }

local keybinds = {
  -- Shortcut so it's easy to exit only with the left hand
  { "n",          "Q",         ":qa<CR>" },

  -- Alternative key to escape terminal, necessary since the original
  -- keybinding can't be expressed on a Mac keyboard
  { "t",          "ń",         "<C-\\><C-n>" },
  { "t",          "Ǹ",         "<C-\\><C-n>" },

  -- Shortcuts for saving the document, with and without autocommands
  { "n",          "<Leader>w", ":w<CR>" },
  { "n",          "<Leader>W", ":noauto w<CR>" },

  -- Shortcut for yank/paste to/from system clipboard
  { { "n", "v" }, "<Leader>y", '"+y' },
  { { "n", "v" }, "<Leader>p", '"+p' },

  -- Press ESC to remove search highlights and clear text from command line and
  -- dismiss notifications
  {
    "n",
    "<Esc>",
    function()
      vim.cmd(":nohl")
      vim.cmd(":echo")
      vim.cmd("silent! exec copilot#Dismiss()")
      require("hubro.close_floats")()
      soft_require("notify", function(notify)
        notify.dismiss()
      end)
    end,
  },

  -- Press Space to toggle folds
  -- { "n", "<Space>", "za" },
  -- { "n", "<S-Space>", "zA" },

  -- Moving the cursor up/down more than 1 line at a time should add an entry
  -- to the jump list (<C-o>/<C-i>)
  --
  -- ref: https://vi.stackexchange.com/a/7697/1891
  --
  { "n", "j",                     [[(v:count > 10 ? "m'" . v:count : '') . 'j']], { expr = true } },
  { "n", "k",                     [[(v:count > 10 ? "m'" . v:count : '') . 'k']], { expr = true } },

  -- Move lines up/down
  { "n", "<A-k>",                 ":m -2<CR>" },
  { "n", "<A-j>",                 ":m +1<CR>" },

  -- Move selection up/down
  { "v", "<A-k>",                 ":m '<-2'<CR>gv" },
  { "v", "<A-j>",                 ":m '>+1'<CR>gv" },

  -- Indent/dedent selection without losing selection
  { "v", "<",                     "<gv" },
  { "v", ">",                     ">gv" },

  -- Easier window navigation
  { "n", "<C-h>",                 "<C-w>h" },
  { "n", "<C-j>",                 "<C-w>j" },
  { "n", "<C-k>",                 "<C-w>k" },
  { "n", "<C-l>",                 "<C-w>l" },

  -- Easier tab navigation
  { "n", "<A-l>",                 ":tabnext<CR>" },    -- Next tab
  { "n", "<A-h>",                 ":tabprev<CR>" },    -- Previous tab
  { "n", "<A-L>",                 ":tabmove +1<CR>" }, -- Move tab right
  { "n", "<A-H>",                 ":tabmove -1<CR>" }, -- Move tab left

  -- Quick horizontal window resizing using Alt + [><+-]
  { "n", "<M-lt>",                "<" },
  { "n", "<M->>",                 ">" },
  { "n", "<M-+>",                 "+" },
  { "n", "<M-->",                 "-" },

  -- Pressing * in visual mode should search for the selected text, then select
  -- the next search result so * can be pressed repeatedly to move forwards.
  { "v", "*",                     '"sy/<C-r>s<CR>gn' },

  -- Pressing # in visual mode should do the same as *, but backwards.
  { "v", "#",                     '"sy?<C-r>s<CR>gn' },

  -- Text wrapping keybinds inspired by Sublime Text
  { "i", "<A-w>",                 "<Esc>0gqq0A" }, -- Wrap the current line while in insert mode
  { "i", "<A-q>",                 "<Esc>0V{gqA" }, -- Wrap the current paragraph in insert mode
  { "n", "<A-q>",                 "gqip" },        -- Wrap the current paragraph in normal mode

  -- Faster mouse scrolling while holding alt
  { "n", "<A-ScrollWheelUp>",     "12<C-y>" },
  { "n", "<A-ScrollWheelDown>",   "12<C-e>" },
  { "v", "<A-ScrollWheelUp>",     "12<C-y>" },
  { "v", "<A-ScrollWheelDown>",   "12<C-e>" },
  { "x", "<A-ScrollWheelUp>",     "12<C-y>" },
  { "x", "<A-ScrollWheelDown>",   "12<C-e>" },
  { "i", "<A-ScrollWheelUp>",     "<C-o>12<C-y>" },
  { "i", "<A-ScrollWheelDown>",   "<C-o>12<C-e>" },

  -- Horizontal mouse scrolling
  { "n", "<S-ScrollWheelUp>",     "5zh" },
  { "n", "<S-ScrollWheelDown>",   "5zl" },
  { "v", "<S-ScrollWheelUp>",     "5zh" },
  { "v", "<S-ScrollWheelDown>",   "5zl" },
  { "x", "<S-ScrollWheelUp>",     "5zh" },
  { "x", "<S-ScrollWheelDown>",   "5zl" },
  { "i", "<S-ScrollWheelUp>",     "<C-o>5zh" },
  { "i", "<S-ScrollWheelDown>",   "<C-o>5zl" },

  -- Faster horizontal mouse scrolling while holding alt
  { "n", "<A-S-ScrollWheelUp>",   "15zh" },
  { "n", "<A-S-ScrollWheelDown>", "15zl" },
  { "v", "<A-S-ScrollWheelUp>",   "15zh" },
  { "v", "<A-S-ScrollWheelDown>", "15zl" },
  { "x", "<A-S-ScrollWheelUp>",   "15zh" },
  { "x", "<A-S-ScrollWheelDown>", "15zl" },
  { "i", "<A-S-ScrollWheelUp>",   "<C-o>15zh" },
  { "i", "<A-S-ScrollWheelDown>", "<C-o>15zl" },

  -- GUI only keybinds (i.e. Neovide)
  { "i", "<C-V>",                 "<C-r>+" }, -- Ctrl+Shift+v, paste system clipboard

  --
  -- Plugin keybinds
  --

  -- Silence! Disable LSP diagnostics and ALE warnings
  {
    "n",
    "<Leader>s",
    ":lua vim.diagnostic.disable(0)<CR>",
  },
  { "n", "<Leader>S",    ":lua vim.diagnostic.enable(0)<CR>" },

  -- Some Fugitive shortcuts
  { "n", "<Leader>gs",   ":tab G<CR>" },
  { "n", "<Leader>gl",   ":tab Git log<CR>" },
  { "n", "<Leader>gpp",  ":G push<CR>" },
  { "n", "<Leader>gP",   ":G push -f<CR>" },
  { "n", "<Leader>gpf",  ":G push -f<CR>" },
  { "n", "<Leader>gpsu", ":G push -u origin HEAD<CR>" },

  -- Jump to git hunk (gitsigns.nvim)
  -- { "n", "[c", ":silent :Gitsigns prev_hunk<CR>" },
  -- { "n", "]c", ":silent :Gitsigns next_hunk<CR>" },
  --
  -- These are now enabled through nvim-next instead, to make them
  -- repeatable

  -- Git blame current lint (gitsigns.nvim)
  { "n", "<Leader>gb",   ":silent :Gitsigns blame_line<CR>" },

  -- Git reset current hunk (gitsigns.nvim)
  { "n", "<Leader>r",    ":silent :Gitsigns reset_hunk<CR>" },
  { "n", "<Leader>grr",  ":silent :Gitsigns reset_hunk<CR>" },
  { "n", "<Leader>grh",  ":silent :Gitsigns reset_hunk<CR>" },
  --
  -- Git reset current buffer (gitsigns.nvim)
  { "n", "<Leader>R",    ":silent :Gitsigns reset_buffer<CR>" },
  { "n", "<Leader>grb",  ":silent :Gitsigns reset_buffer<CR>" },

  -- Git reset selected lines
  { "v", "<Leader>gr",   ":'<,'>:Gitsigns reset_hunk<CR>" },
  { "v", "<Leader>R",    ":'<,'>:Gitsigns reset_hunk<CR>" },

  -- Telescope - Find files
  { "n", "<C-p>",        ":Telescope find_files<CR>" },

  -- Telescope - Find files tracked by Git
  { "n", "<M-p>",        ":Telescope git_files<CR>" },

  -- Telescope - File history
  { "n", "<C-A-p>",      ":Telescope oldfiles<CR>" },
  { "n", "<Bar>h",       ":Telescope oldfiles only_cwd=true<CR>" }, -- Change this to only show files in CWD
  { "n", "<Bar>H",       ":Telescope oldfiles<CR>" },

  -- Telescope - List buffers
  { "n", "<Bar>b",       ":Telescope buffers theme=ivy previewer=false<CR>" },

  -- Telescope - Show document outline using LSP symbols
  { "n", "<Bar>o",       ":Telescope lsp_document_symbols theme=outline<CR>" },

  -- Telescope - Show Ultisnips snippets
  { "n", "<Bar>s",       ":Telescope ultisnips theme=ultisnips<CR>" },
  { "i", "<C-s>",        "<Space><BS><Esc>:Telescope ultisnips theme=ultisnips<CR>" },

  -- Telescope - Live grep
  { "n", "<Bar>gr",      ":Telescope live_grep<CR>" },

  -- Telescope - Git status
  { "n", "<Bar>gs",      ":Telescope git_status<CR>" },

  -- Telescope - Show LSP code actions
  { "n", "<Bar>la",      ":Telescope lsp_code_actions theme=get_dropdown<CR>" },

  -- Telescope - Show LSP references
  { "n", "<Bar>lr",      ":Telescope lsp_references<CR>" },

  -- Telescope - Go to project
  { "n", "<Bar>p",       ":Telescope nvim-projects<CR>" },

  -- Telescope - Resume last session
  { "n", "<Bar><Bar>",   ":Telescope resume<CR>" },

  -- Toggle file tree (nvim-tree.lua)
  { "n", "<Leader>t",    ":Neotree toggle reveal_force_cwd<CR>" },
  { "n", "gt",           ":Neotree reveal<CR>" }, -- Open current file in the tree
  { "n", "gT",           ":Neotree float reveal_file=<cfile> reveal_force_cwd<CR>" },

  -- Toggle document outline (See "aerial" in plugins)
  { "n", "<Leader>o", function()
    -- NOTE: Workaround for https://github.com/stevearc/aerial.nvim/issues/331
    require('aerial').refetch_symbols()
    vim.cmd.AerialOpen 'float'
    vim.cmd.doautocmd 'BufWinEnter'
  end },
  --{ "n", "<Leader>o",   ":AerialNavToggle<CR>" },

  -- Zen mode
  { "n", "<F11>",     ":silent :ZenMode<CR>" },

  -- Toggle light/dark mode
  { "n", "<F12>",     ":lua toggle_colorscheme()<CR>" },

  -- Show diagnostics window ("trouble.nvim" plugin)
  { "n", "<Leader>d", ":Trouble document_diagnostics<CR>" },
  { "n", "<Leader>D", ":Trouble workspace_diagnostics<CR>" },
  { "n", "<Leader>q", ":Trouble quickfix<CR>" },
  { "n", ")",         "<Plug>(ale_next_wrap)",                  { noremap = false } },
  { "n", "(",         "<Plug>(ale_previous_wrap)",              { noremap = false } },

  -- Floating terminal ("vim-floaterm" plugin)
  { "n", "<C-q>",     ":FloatermToggle<CR>" },

  -- Open a new embedded terminal in a split
  { "n", "<F1>",      ":vsplit<CR>:terminal<CR>i" },
  { "n", "<S-F1>",    ":split<CR>:terminal<CR>i" },

  { "n", "<F10>",     [[:lua require("hubro.lspformat")()<CR>]] },

  -- CTRL+Enter creates a new line below the current line, Shift+Enter creates
  -- a line above the current line. (These only work in GUIs.)
  { "i", "<C-CR>",    "<Esc>o" },
  { "i", "<S-CR>",    "<Esc>O" },

  -- Press Alt+N to go from block select mode to multiple cursors
  { "x", "<A-n>",     "<Plug>(VM-Visual-Cursors)",              { noremap = false } },

  -- Remap shift+space in terminal mode in Neovide, as the default is buggy
  { "t", "<S-Space>", "<Space>",                                { gui = true } },

  -- Zoom in/out in a GUI (uses vim-gui-zoom plugin)
  {
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { gui = true },
  },
  {
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { gui = true },
  },
  { "n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { gui = true } },

  -- Set specific font sizes using Alt+1/2/3
  {
    "n",
    "<A-1>",
    ":lua vim.opt.guifont = vim.g.hubro_default_font<CR>",
    { gui = true },
  },
  {
    "n",
    "<A-2>",
    ":lua vim.opt.guifont = vim.g.hubro_big_font<CR>",
    { gui = true },
  },
  {
    "n",
    "<A-3>",
    ":lua vim.opt.guifont = vim.g.hubro_huge_font<CR>",
    { gui = true },
  },
}

-- {{{ The magic
_G.apply_keybinds = function(keybinds)
  for _, bind in ipairs(keybinds) do
    if #bind < 4 then
      bind[4] = default_opts
    else
      bind[4] = vim.tbl_extend("force", default_opts, bind[4])
    end

    if bind[4].mac then
      bind[4].mac = nil

      if vim.fn.has("macunix") == 0 then
        -- This is a mac-only keybind and this is not a MacOS system, so ignore
        -- this keybind
        goto continue
      end
    end

    if bind[4].gui then
      bind[4].gui = nil

      if vim.g.neovide ~= true then
        -- This is a GUI-only keybind, so if we're not running in Neovide,
        -- ignore this keybind
        goto continue
      end
    end

    vim.keymap.set(unpack(bind))

    ::continue::
  end
end

apply_keybinds(keybinds)
-- }}}
