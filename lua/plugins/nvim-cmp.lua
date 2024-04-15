return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "quangnguyen30192/cmp-nvim-ultisnips",
    "onsails/lspkind.nvim", -- LSP icons
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    local buffer = function(opts)
      if not opts then
        opts = {}
      end

      local source = {
        name = "buffer",
        option = { keyword_pattern = [[\k\+]] },
      }

      if opts.all_buffers then
        source.option.get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      end

      return source
    end

    local types = require("cmp.types")

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
      ["<Right>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }

    vim.opt.completeopt = "menu,menuone,noselect"

    --- My custom sort order scoring for LSP completion items
    ---
    --- A higher score means it should go higher up in the list.
    ---
    ---@type fun(client: vim.lsp.Client, item: lsp.CompletionItem): integer
    local score_lsp_completion_item = function(client, item)
      local score = 0
      local kind = vim.lsp.protocol.CompletionItemKind[item.kind]

      local kind_score = {
        EnumMember = 20,
        Field = 10,
        Method = 10,
        Property = 10,
        Snippet = 10,
        Constant = 5,
        Function = 5,
        Keyword = 5,
        TypeParameter = 5,
        Value = 5,
        Variable = 5,
        Class = 0,
        Color = 0,
        Constructor = 0,
        Enum = 0,
        Event = 0,
        File = 0,
        Folder = 0,
        Interface = 0,
        Module = 0,
        Operator = 0,
        Reference = 0,
        Struct = 0,
        Text = 0,
        Unit = 0,
      }

      score = score + (kind_score[kind] or 0)

      if client.name == "rust_analyzer" then
        -- If the completion item requires an import, it should be at the bottom
        if item.data ~= nil and item.data.imports ~= nil then
          score = score - 100
        end
      end

      if client.name == "pyright" then
        -- Hidden properties should have lower prio
        if item.label:match("^_") then
          score = score - 1
        end

        -- Mangled properties should have even lower prio
        if item.label:match("^__") then
          score = score - 1
        end
      end

      return score
    end

    --- Custom sort order for completion entries
    ---
    --- Should return "true" if entry1 should be higher up in the list than
    --- entry2. Otherwise should return "nil".
    ---
    ---@type fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
    local cmp_lsp_custom = function(entry1, entry2)
      if entry1.source.name ~= "nvim_lsp" or entry2.source.name ~= "nvim_lsp" then
        return nil
      end

      local lspclient1 = entry1.source.source.client
      local item1 = entry1:get_completion_item()

      local lspclient2 = entry2.source.source.client
      local item2 = entry2:get_completion_item()

      -- If the LSP provides sortText then trust that. Pyright uses this to
      -- provide a logical order to completion suggestions.
      if item1.sortText and item2.sortText then
        local text_order = cmp.config.compare.sort_text(entry1, entry2)

        if text_order ~= nil then
          return text_order
        end
      end

      local score1 = score_lsp_completion_item(lspclient1, item1)
      local score2 = score_lsp_completion_item(lspclient2, item2)

      if score1 > score2 then
        return true
      elseif score2 > score1 then
        return false
      else
        return nil
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert(MAPPING),
      sources = {
        { name = "ultisnips", group_index = 1, priority = 2 },
        { name = "nvim_lsp",  group_index = 1, priority = 1 },

        { name = "path",      group_index = 2, priority = 10 },
        {
          name = "buffer",
          group_index = 2,
          priority = 1,
          option = {
            keyword_pattern = [[\k\+]],
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          },
        },

        --{ name = "buffer",    group_index = 2, option = { keyword_pattern = [[\k\+]] } },
        --{ name = "path",      group_index = 2 },

        -- If nothing else matches, complete words from other buffers
        --{
        --  name = "buffer",
        --  group_index = 3,
        --  option = {
        --    keyword_pattern = [[\k\+]],
        --    get_bufnrs = function()
        --      return vim.api.nvim_list_bufs()
        --    end
        --  },
        --},
      },
      sorting = {
        priority_weight = 1,
        comparators = {
          cmp.config.compare.exact,
          cmp_lsp_custom,
          cmp.config.compare.scopes,
          cmp.config.compare.locality,
          cmp.config.compare.sort_text,
        },
      },
      ---@diagnostic disable-next-line: missing-fields
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
      },
      experimental = {
        native_menu = false,
        ghost_text = false, -- Conflicts with copilot.nvim
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
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
          name = "buffer",
          buffer({ all_buffers = true }),
        },
      },
    })
  end
}
