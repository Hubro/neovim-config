return {
  { "tpope/vim-repeat",     lazy = false },  -- Allows plugins to implement proper repeat support
  { "tpope/vim-surround",   event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },
  { "tpope/vim-fugitive",   cmd = { "G" } },
  { "tpope/vim-sleuth",     lazy = false },       -- Smartly detect shiftwidth and related settings
  { "tpope/vim-eunuch",     event = "VeryLazy" }, -- Adds common Unix command helpers like ":Rename"
}
