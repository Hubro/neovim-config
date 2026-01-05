-- rust-tools.nvim - Auto-setup of LSP and debugging + nice commands
return {
  "mrcjkb/rustaceanvim",
  version = '^6',
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      tools = {
        -- ...
      },
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            -- ...
          },
        },
        on_attach = function(client, bufnr)
          require("hubro.lsp_on_attach")(client, bufnr)

          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "K", ":RustLsp hover actions<CR>", opts)
          vim.keymap.set("n", "<Leader>rr", ":RustLsp runnables<CR>", opts)
          vim.keymap.set("n", "<Leader>re", ":RustLsp expandMacro<CR>", opts)
          vim.keymap.set("n", "<Leader>rc", ":RustLsp openCargo<CR>", opts)
        end,
      },
      dap = {
        -- ...
      },
    }
  end,
}
