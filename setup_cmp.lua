
local installed, cmp = pcall(require, "cmp")

local buffer = function(opts)
    if not opts then
        opts = {}
    end

    local source = {
        name = "buffer",
        options = { keyword_pattern = [[\k\+]] }
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
        ['<C-n>'] = {
            i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
        },
        ['<C-p>'] = {
            i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
        },
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }

    vim.opt.completeopt = "menu,menuone,noselect"

    cmp.setup{
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert(MAPPING),
        sources = cmp.config.sources(
            {
                { name = "ultisnips" },
                { name = "nvim_lsp" },
            },
            {
                buffer(),
                { name = "path" },
            }
        )
    }

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                { name = "cmdline" },
            },
            {
                { name = "path" },
                buffer{ all_buffers = true }
            }
        ),
        completion = {
            keyword_length = 1
        }
    })

    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            {
                buffer{ all_buffers = true }
            },
        }
    })
end
