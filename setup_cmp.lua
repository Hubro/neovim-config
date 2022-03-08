
local installed, cmp = pcall(require, "cmp")

if installed then
    vim.opt.completeopt = "menu,menuone,noselect"

    cmp.setup{
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        mapping = {
            ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<Tab>"] = cmp.mapping(cmp.mapping.confirm({ select = true })),
        },
        sources = cmp.config.sources(
            {
                { name = "ultisnips" },
                { name = "nvim_lsp" },
            },
            {
                { name = "buffer" },
                { name = "path" },
                { name = "cmdline" },
            }
        )
    }

    cmp.setup.cmdline(":", {
        sources = {
            { name = "cmdline" },
            { name = "path" },
            { name = "buffer" },
        }
    })

    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        }
    })
end
