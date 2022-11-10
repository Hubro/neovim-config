local installed, cmp = pcall(require, "cmp")
local lspkind_installed, lspkind = pcall(require, "lspkind")

local buffer = function(opts)
  if not opts then
    opts = {}
  end

  local source = {
    name = "buffer",
    options = { keyword_pattern = [[\k\+]] },
  }

  if opts.all_buffers then
    source.options.get_bufnrs = function()
      return vim.api.nvim_list_bufs()
    end
  end

  return source
end

if installed then
  types = require("cmp.types")

  local MAPPING = {
    ["<C-n>"] = {
      i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ["<C-p>"] = {
      i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }

  vim.opt.completeopt = "menu,menuone,noselect"

  local formatting = {}

  if lspkind_installed then
    -- https://github.com/onsails/lspkind.nvim
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[api]",
          path = "[path]",
          ultisnips = "[snip]",
        },
      }),
    }
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert(MAPPING),
    sources = cmp.config.sources({
      { name = "ultisnips" },
      { name = "nvim_lsp" },
    }, {
      buffer(),
      { name = "path" },
    }),
    formatting = formatting,
    experimental = {
      native_menu = false,
      ghost_text = true,
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "cmdline" },
    }),
    completion = {
      keyword_length = 1,
    },
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      {
        buffer({ all_buffers = true }),
      },
    },
  })
end
