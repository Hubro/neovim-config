local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

function setup_file(name)
  return function()
    vim.cmd("runtime setup_" .. name .. ".lua")
  end
end

require("lazy").setup({

  -- =============================
  -- === Absolute core plugins ===
  -- =============================

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "windwp/nvim-ts-autotag",
    },
    config = setup_file("treesitter"),
    -- setup = function()
    --   vim.cmd[[ runtime setup_treesitter.lua ]]
    -- end
  },
  {
    "neovim/nvim-lspconfig",
    -- setup = setup_file("lsp"),
    config = function()
      vim.cmd([[ runtime setup_lsp.lua ]])
    end,
  },

  -- Mandatory tpope goodness
  "tpope/vim-repeat", -- Allows plugins to implement proper repeat support
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-sleuth", -- Smartly detect shiftwidth and related settings
  "tpope/vim-eunuch", -- Adds common Unix command helpers like ":Rename"
  "tpope/vim-unimpaired", -- Pairs of handy bracket mappings

  -- EditorConfig support
  "editorconfig/editorconfig-vim",

  -- Multiple cursors
  "mg979/vim-visual-multi",

  -- Automatically close quotes and parentheses
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
      vim.g.AutoPairsShortcutFastWrap = ""
      vim.g.AutoPairsShortcutJump = ""
      vim.g.AutoPairsShortcutBackInsert = ""
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "fhill2/telescope-ultisnips.nvim",
    },
    config = setup_file("telescope"),
  },

  -- Document outline with LSP and Tree-sitter backends
  {
    "stevearc/aerial.nvim",
    opts = {
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
      },
    },
  },

  -- Asynchronous linter engine
  {
    "dense-analysis/ale",
    init = function()
      vim.g.ale_linters_explicit = "1" -- Only run stuff I explicitly enable
      vim.g.ale_disable_lsp = "1"
    end,
  },

  -- Snippet support
  {
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsEditSplit = "horizontal"

      -- Expansion is done by nvim-compe
      vim.g.UltiSnipsExpandTrigger = "<Plug>UltisnipsExpand"
    end,
  },

  -- Auto-completion dropdown
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "onsails/lspkind.nvim", -- LSP icons
    },
    config = setup_file("cmp"),
  },

  -- Extensible plugin for auto-formatting code
  { "mhartington/formatter.nvim", config = setup_file("formatter") },

  -- ========================
  -- === Nice extra tools ===
  -- ========================

  -- Floating terminal
  "voldikss/vim-floaterm",

  -- Trouble - Nicely formatted quickfix and diagnostics list
  {
    "folke/trouble.nvim",
    opts = {
      height = 20,
      auto_preview = false,
      action_keys = {
        toggle_fold = { "zA", "za", "<Space>" },
        jump_close = { "<cr>" }, -- Use <Tab> to jump without closing
      },
    },
  },

  -- which-key
  { "folke/which-key.nvim", config = true },

  -- Leap.nvim - Neovim's answer to the mouse, quick on-screen navigation
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "å", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "Å", "<Plug>(leap-backward-to)")
      vim.keymap.set({ "n", "x", "o" }, "gå", "<Plug>(leap-cross-window)")
    end,
  },

  -- nvim-tree.lua
  {
    "kyazdani42/nvim-tree.lua",
    config = setup_file("nvim_tree"),
  },

  -- Lazygit integration
  { "kdheepak/lazygit.nvim", command = "LazyGit" },

  -- =============
  -- === Bling ===
  -- =============

  -- Git indicators in the gutter
  "lewis6991/gitsigns.nvim",

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-lua/lsp-status.nvim", -- LSP status component
      "SmiteshP/nvim-gps", -- Code position breadcrumbs status component
    },
    config = setup_file("lualine"),
  },

  -- Floating scrollbar
  { "dstein64/nvim-scrollview", config = true },

  -- Indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    -- mod = "indent_blankline",
    opts = {
      show_current_context = true,
      -- show_current_context_start = true,
      char = "▎",
    },
  },

  -- ========================
  -- === Lancuage support ===
  -- ========================

  -- Python - Black auto-formatting
  "psf/black",

  -- SystemD - Syntax highlighting
  "wgwoods/vim-systemd-syntax",

  -- Markdown - Live preview server
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  {
    "mzlogin/vim-markdown-toc",
    commit = "7ec05df27b4922830ace2246de36ac7e53bea1db",
  },

  -- Polar - Authorization DSL
  "osohq/polar.vim",

  -- Sway config files
  "terminalnode/sway-vim-syntax",

  -- Kitty config files
  "fladson/vim-kitty",

  -- =====================
  -- === Color schemes ===
  -- =====================

  -- Color schemes
  --"rakr/vim-one", -- One theme (dark and light)
  --"tomasr/molokai", -- Molokai
  --"arcticicestudio/nord-vim", -- Nord
  --"cocopon/iceberg.vim", -- Iceberg
  --"morhetz/gruvbox", -- Gruvbox
  --"lifepillar/vim-gruvbox8", -- Gruvbox (Simplified and optimized)
  ---- "ayu-theme/ayu-vim",        -- Ayu
  --"Shatur/neovim-ayu", -- Ayu (Optimized for Neovim)
  --"folke/tokyonight.nvim", -- TokyoNight
  --"dracula/vim", -- Dracula
  --"NLKNguyen/papercolor-theme", -- PaperColor
  "EdenEast/nightfox.nvim", -- Nightfox
  { "catppuccin/nvim", name = "catppuccin" }, -- Catppuccin
})
