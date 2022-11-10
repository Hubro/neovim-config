
local plugin_install_path = vim.fn.stdpath("data").."/bundle"

-- {{{ Magic Lua juice

vim.cmd[[
  aug init_plugins.lua
    au!
    au BufEnter init_plugins.lua nnoremap <F5> :so %<CR>:PlugInstall<CR>
    au BufEnter init_plugins.lua nnoremap <F6> :so %<CR>:PlugUpdate<CR>
  aug END
]]

local plug = function(definitions)
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
        if plugin[2].run ~= nil then
          plugin[2]["do"] = plugin[2].run
          plugin[2].run = nil
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
    soft_setup("nvim-web-devicons", { default = true })
  end },

  -- }}}

  -- Official plugins
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter", { setup = "treesitter" },
  "neovim/nvim-lspconfig", { setup = "lsp" },

  -- Mandatory tpope goodness
  "tpope/vim-repeat",  -- Lets plugins implement proper repeat support
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-sleuth",  -- Smartly detect shiftwidth and related settings
  "tpope/vim-eunuch",  -- Adds common Unix command helpers like ":Rename"
  "tpope/vim-unimpaired",  -- Pairs of handy bracket mappings

  -- Extra text objects
  "kana/vim-textobj-user",             -- Common dependency
  "wellle/targets.vim",                -- Lots of generic useful ones
  "glts/vim-textobj-comment",          -- Comments (language agnostic)
  "jeetsukumaran/vim-pythonsense", {   -- Functions, classes and docstrings
    ["g:is_pythonsense_suppress_object_keymaps"] = 1,
    ["g:is_pythonsense_suppress_motion_keymaps"] = 1,
    ["g:is_pythonsense_suppress_location_keymaps"] = 1,
    -- Custom keymaps are set in ftplugin/python.lua
  },

  -- Basic syntax checking for a crapload of languages
  "vim-syntastic/syntastic", {
    ["g:syntastic_always_populate_loc_list"] = "1",
    ["g:syntastic_auto_loc_list"] = "0",
    ["g:syntastic_check_on_open"] = "1",
    ["g:syntastic_check_on_wq"] = "0",
    ["g:syntastic_python_checkers"] = {},
  },

  -- "airblade/vim-gitgutter",
  "lewis6991/gitsigns.nvim", { setup = function() soft_setup("gitsigns") end },

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
  "dense-analysis/ale", {
    ["g:ale_linters_explicit"] = "1",   -- Only run stuff I explicitly enable
    ["g:ale_disable_lsp"] = "1",
  },

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
  "onsails/lspkind.nvim",   -- LSP icons
  "hrsh7th/nvim-cmp", { setup = "cmp" },

  -- Trouble - Nicely formatted quickfix and diagnostics list
  "folke/trouble.nvim", { setup = "trouble" },

  -- Lazygit integration
  "kdheepak/lazygit.nvim",

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
  --"simrat39/symbols-outline.nvim", {
  --  setup = function()
  --    soft_setup("symbols-outline", {
  --      width = 40,
  --      symbol_blacklist = {
  --        "Property", "Field", "Variable", "Key", "EnumMember", "TypeParameter"
  --      }
  --    })
  --  end
  --},

  -- Document outline with LSP and Tree-sitter backends
  "stevearc/aerial.nvim", {
    setup = function()
      -- vim.treesitter.set_query("bash", "aerial", [[
      --   (function_definition
      --     name: (word) @name) @type

      --   (declaration_command
      --     (variable_assignment
      --       name: (variable_name) @name)) @type
      -- ]])

      -- local map = require("aerial/backends/treesitter/language_kind_map")
      -- map.bash.declaration_command = "Field"

      soft_setup("aerial", {
        backends = { "treesitter", "lsp", "markdown" },
        layout = {
          max_width = { 80, 0.9 },
          min_width = 60,
        },
        keymaps = {
          ["<Esc>"] = "actions.close",
        },
        close_on_select = true,
        float = {
          relative = "win",
        }
      })
    end
  },

  -- Zen mode
  "folke/twilight.nvim", {
    setup = function()
      soft_setup("twilight", {
        context = 20,
        expand = { "function", "function_definition", "decorated_definition" },
      })
    end
  },
  -- "folke/zen-mode.nvim", {
  { "nasanos/zen-mode.nvim", { branch = "keep-cursor-position-on-exit" } }, {
    setup = function()
      soft_setup("zen-mode", {
        window = {

        },
        plugins = {
          gitsigns = { enabled = true },

          -- Twilight is cool but needs some work
          twilight = { enabled = false },
        },
        on_open = function(win)
          vim.cmd("ALEDisableBuffer")
          vim.cmd("ScrollViewDisable")
          vim.diagnostic.disable()

          -- Currently, changing the font causes Zen mode to scale incorrectly.
          -- Follow: https://github.com/folke/zen-mode.nvim/issues/45
          --
          -- vim.opt.guifont = "SauceCodePro Nerd Font:h12:w57"
        end,
        on_close = function(win)
          vim.cmd("ALEEnableBuffer")
          vim.cmd("ScrollViewEnable")
          vim.diagnostic.enable()
          -- vim.opt.guifont = "SauceCodePro Nerd Font:h9:w57"
        end,
      })
    end
  },

  -- Control 'guifont' to zoom in/out in a GUI
  "drzel/vim-gui-zoom",

  -- Floating scrollbar
  "dstein64/nvim-scrollview", {
    setup = function()
      soft_setup("scrollview")
    end
  },

  -- {{{ Language support

  -- Neovim plugin development support, sets up Lua LSP and such
  "folke/neodev.nvim", {
    setup = function()
      soft_setup("neodev", {
        override = function(_, options)
          if (
            vim.fn.expand("%") == ".nvimrc.lua"
            or vim.fn.expand("%") == ".nvimrc-post.lua"
          ) then
            options.enabled = true
          end
        end
      })

      soft_require("lspconfig", function(lspconfig)
        -- I currently only use Lua for Neovim config, so might as well enable
        -- neodev globally
        lspconfig.sumneko_lua.setup {
          on_attach = _G.lsp_on_attach,

          Lua = {
              runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
              },
              diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = {'vim'},
              },
              workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
              },
          }
        }
      end)
    end
  },

  -- Robot Framework syntax highlighting
  "mfukar/robotframework-vim",

  -- Python - Better indentation expression (indentexpr)
  -- "Vimjas/vim-python-pep8-indent", {
  --   -- https://github.com/Vimjas/vim-python-pep8-indent#gpython_pep8_indent_multiline_string
  --   ["g:python_pep8_indent_multiline_string"] = -2
  -- },

  -- Python - Black auto-formatting
  "psf/black",

  -- SystemD - Syntax highlighting
  "wgwoods/vim-systemd-syntax",

  -- Markdown - Live preview server
  { "iamcco/markdown-preview.nvim", { run = "cd app && yarn install" } },

  -- Polar - Authorization DSL
  "osohq/polar.vim",

  -- Sway config files
  "terminalnode/sway-vim-syntax",

  -- }}}

  -- Color schemes
  "rakr/vim-one",                -- One theme (dark and light)
  "tomasr/molokai",              -- Molokai
  "arcticicestudio/nord-vim",    -- Nord
  "cocopon/iceberg.vim",         -- Iceberg
  "morhetz/gruvbox",             -- Gruvbox
  "lifepillar/vim-gruvbox8",     -- Gruvbox (Simplified and optimized)
  -- "ayu-theme/ayu-vim",        -- Ayu
  "Shatur/neovim-ayu",           -- Ayu (Optimized for Neovim)
  "folke/tokyonight.nvim",       -- TokyoNight
  "dracula/vim",                 -- Dracula
  "NLKNguyen/papercolor-theme",  -- PaperColor
  "EdenEast/nightfox.nvim",      -- Nightfox
}
