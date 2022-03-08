
local plugin_install_path = vim.fn.stdpath("data").."/bundle"

-- {{{ Magic Lua juice

vim.cmd[[
  aug init_plugins.lua
    au!
    au BufEnter init_plugins.lua nnoremap <F5> :so %<CR>:PlugInstall<CR>
    au BufEnter init_plugins.lua nnoremap <F6> :so %<CR>:PlugUpdate<CR>
  aug END
]]

function plug(definitions)
  local plugins_to_set_up = {}

  vim.fn["plug#begin"](plugin_install_path)

  for i, plugin in ipairs(definitions) do
    if type(plugin) == "string" then
      vim.fn["plug#"](plugin)
    end

    if type(plugin) == "table" then
      -- If this is a key/value table, it will contain special instructions and
      -- global options
      if plugin[1] == nil then
        for key, value in pairs(plugin) do
          if key:sub(1, 2) == "g:" then
            -- This is a global option!
            vim.g[key:sub(3, #key)] = value
          elseif key == "setup" then
            table.insert(plugins_to_set_up, value)
          else
            error("Unknown plugin instruction: " .. key)
          end
        end
      -- Otherwise, this is a plug# call with options. We'll pass these more or
      -- less directly to plug#, but with some aliases switched out to avoid
      -- reserved keywords.
      else
        if plugin.run ~= nil then
          plugin["do"] = plugin.run
          plugin.run = nil
        end

        vim.fn["plug#"](unpack(plugin))
      end
    end
  end

  vim.fn["plug#end"]()

  -- All plugins should now be loaded, so it's safe to set them up
  for _, setup in ipairs(plugins_to_set_up) do
    if type(setup) == "string" then
      vim.cmd("runtime setup_" .. setup .. ".lua")
    elseif type(setup) == "function" then
      setup()
    else
      error("Unexpected setup type: " .. type(setup))
    end
  end
end

-- }}}

plug {
  -- {{{ Common dependencies

  -- Utilities for Lua scripting in Neovim
  "nvim-lua/plenary.nvim",

  -- Implementation of Vim's popup API in Neovim
  "nvim-lua/popup.nvim",

  -- Extra icon support
  "ryanoasis/vim-devicons",
  "kyazdani42/nvim-web-devicons", { setup = function()
    require("nvim-web-devicons").setup{ default = true }
  end },

  -- }}}

  -- Official plugins
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter", { setup = "treesitter" },
  "neovim/nvim-lspconfig", { setup = "lsp" },

  -- tpope goodness
  "tpope/vim-repeat",  -- Lets plugins implement proper repeat support
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-sleuth",  -- Smartly detect shiftwidth and related settings
  "tpope/vim-eunuch",  -- Adds common Unix command helpers like ":Rename"

  "airblade/vim-gitgutter",

  -- EditorConfig support
  "editorconfig/editorconfig-vim",

  -- Multiple cursors
  "mg979/vim-visual-multi",

  -- Automatically close quotes and parentheses
  "jiangmiao/auto-pairs", {
    ["g:AutoPairsShortcutToggle"] = "",
    ["g:AutoPairsShortcutFastWrap"] = "",
    ["g:AutoPairsShortcutJump"] = "",
    ["g:AutoPairsShortcutBackInsert"] = "<A-b>",
  },

  -- Automatically close HTML/XML tags
  -- "alvan/vim-closetag",
  "windwp/nvim-ts-autotag",

  -- Asynchronous linter engine
  "dense-analysis/ale",

  -- Snippet support
  "SirVer/ultisnips", {
    ["g:UltiSnipsEditSplit"] = "horizontal",
    -- Expansion is done by nvim-compe
    ["g:UltiSnipsExpandTrigger"] = "<Plug>UltisnipsExpand",
  },

  -- Auto completion suggestions, with LSP and snippet integration
  -- "hrsh7th/nvim-compe", { setup = "compe" },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "quangnguyen30192/cmp-nvim-ultisnips",
  "hrsh7th/nvim-cmp", { setup = "cmp" },

  -- Trouble - Nicely formatted quickfix and diagnostics list
  "folke/trouble.nvim", { setup = "trouble" },

  -- Floating terminal
  "voldikss/vim-floaterm",

  -- Extensible plugin for auto-formatting code
  "sbdchd/neoformat", {
    ["g:neoformat_enabled_javascript"] = { "prettier" },
    ["g:neoformat_enabled_javascriptreact"] = { "prettier" },
    ["g:neoformat_enabled_typescript"] = { "prettier" },
    ["g:neoformat_enabled_typescriptreact"] = { "prettier" },
  },

  -- Telescope
  "fhill2/telescope-ultisnips.nvim",
  "nvim-telescope/telescope.nvim", { setup = "telescope" },

  -- Lualine
  "nvim-lua/lsp-status.nvim",  -- LSP status component
  --"~/src/github/Hubro/nvim-gps",
  "SmiteshP/nvim-gps",  -- Code position breadcrumbs status component
  "nvim-lualine/lualine.nvim", { setup = "lualine" },

  -- nvim-tree.lua
  "kyazdani42/nvim-tree.lua", {
    -- ["g:nvim_tree_ignore"] = {".git", "node_modules", "__pycache__"},
    setup = "nvim_tree"
  },

  -- Whitespace auto stripping
  "ntpeters/vim-better-whitespace", {
    ["g:better_whitespace_enabled"] = false,  -- Don't highlight whitespace
    ["g:strip_whitespace_on_save"] = true,
    ["g:strip_whitelines_at_eof"] = true,  -- Also strip trailing line endings
    ["g:strip_whitespace_confirm"] = false,
  },

  -- Document outline based on LSP
  "simrat39/symbols-outline.nvim", {
    ["g:symbols_outline"] = {
      auto_close = true,
      width = 40,
      symbol_blacklist = {
        "Property", "Field", "Variable", "Key", "EnumMember", "TypeParameter"
      }
    }
  },

  -- Minimap (currently broken when used with fugitive)
  -- "wfxr/minimap.vim", {
  --   ["g:minimap_width"] = 10,
  --   ["g:minimap_auto_start"] = 1,
  --   ["g:minimap_auto_start_win_enter"] = 1,
  --   ["g:minimap_highlight_range"] = 1,
  --   -- ["g:minimap_git_colors"] = 1,

  --   -- Disable minimap for specific file types
  --   ["g:minimap_block_filetypes"] = { "nerdtree" },

  --   -- Disable minimap for specific buffer types
  --   ["g:minimap_block_buftypes"] = { "nofile", "nowrite", "quickfix", "terminal", "prompt" },

  --   -- Close minimap for specific file types
  --   ["g:minimap_close_filetypes"] = { "fugitive", "netrw", "vim-plug" },
  -- },

  -- {{{ Language support

  -- Robot Framework syntax highlighting
  "mfukar/robotframework-vim",

  -- Python - Better indentation expression (indentexpr)
  -- "Vimjas/vim-python-pep8-indent", {
  --   -- https://github.com/Vimjas/vim-python-pep8-indent#gpython_pep8_indent_multiline_string
  --   ["g:python_pep8_indent_multiline_string"] = -2
  -- },

  -- SystemD - Syntax highlighting
  "wgwoods/vim-systemd-syntax",

  -- Markdown - Live preview server
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" },

  -- Polar - Authorization DSL
  "osohq/polar.vim",

  -- Sway config files
  "terminalnode/sway-vim-syntax",

  -- }}}

  -- Color schemes
  "rakr/vim-one",              -- One theme (dark and light)
  "tomasr/molokai",            -- Molokai
  "arcticicestudio/nord-vim",  -- Nord
  "cocopon/iceberg.vim",       -- Iceberg
  "morhetz/gruvbox",           -- Gruvbox
  "lifepillar/vim-gruvbox8",   -- Gruvbox (Simplified and optimized)
  "ayu-theme/ayu-vim",         -- Ayu
  "folke/tokyonight.nvim",     -- TokyoNight
  "dracula/vim",               -- Dracula
}
