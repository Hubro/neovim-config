if lsp_is_configured then
  return
end

_G.lsp_is_configured = true

local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig/configs")
local lsputil = require("lspconfig/util")

-- Handler for when a buffer is connected to a language server
--
-- This function is defined globally so it can be reused in local config
-- files (.nvimrc)
--
_G.lsp_on_attach = function(client, bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = {noremap=true, silent=true}

  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- map('n', '(', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- map('n', ')', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

-- Custom config for YANG language server
--
lspconfig_configs.yang_lsp = {
  default_config = {
    cmd = { "yang-language-server" },
    filetypes = { "yang" },
    root_dir = function(fname)
      return lsputil.root_pattern("yang.settings")(fname)

      -- return lsputil.find_git_ancestor(fname) or
      --   lsputil.root_pattern("yang.settings")(fname) or
      --   lsputil.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
TODO
    ]],
  },
}

-- Custom config for Robot Framework language server
--
lspconfig_configs.robot_lsp = {
  default_config = {
    cmd = { "robotframework_ls" },
    filetypes = { "robot" },
    root_dir = function(fname)
      return lsputil.find_git_ancestor(fname) or
        lsputil.path.dirname(fname)
    end,
    settings = {
        robot = {
            pythonpath = (
              vim.env.PYTHONPATH
              and vim.split(vim.env.PYTHONPATH, ":")
              or { "" }
            )
        },
    },
  },
  docs = {
    description = [[
TODO
    ]],
  },
}

lspconfig.yang_lsp.setup {
  on_attach = _G.lsp_on_attach,
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false
        }
      }
    }
  }
}

vim.lsp.set_log_level("debug")

lspconfig.robot_lsp.setup {
  on_attach = _G.lsp_on_attach,
}

-- lspconfig.pylsp.setup {
--   on_attach = _G.lsp_on_attach,
-- }

lspconfig.tsserver.setup {
  on_attach = _G.lsp_on_attach
}

-- Allow projects to define a post-LSP hook for project specific LSP config
if _G.project_hook_lsp then
  project_hook_lsp()
end
