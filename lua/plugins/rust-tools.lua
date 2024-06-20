-- rust-tools.nvim - Auto-setup of LSP and debugging + nice commands
return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  ft = "rust",
  opts = {
    server = {
      on_attach = function(client, bufnr)
        ---@diagnostic disable-next-line: undefined-field
        _G.lsp_on_attach(client, bufnr) -- Defined in setup_lsp.lua

        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "K", "<cmd>RustHoverActions<CR>", opts)
        vim.keymap.set("n", "<Leader>rr", "<cmd>RustRunnables<CR>", opts)
        vim.keymap.set("n", "<Leader>re", "<cmd>RustExpandMacro<CR>", opts)
        vim.keymap.set("n", "<Leader>rc", "<cmd>RustCargo<CR>", opts)
      end,
    },
    tools = {
      on_initialized = function()
        require("rust-tools").inlay_hints.enable()
      end,
      inlay_hints = {
        -- only_current_line = true,
        -- parameter_hints_prefix = "<-",
        -- other_hints_prefix = "=>",
      },
    },
  },
}
