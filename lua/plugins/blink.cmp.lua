return {
  "saghen/blink.cmp",

  -- TODO: Add UltiSnips support using "blink.compat" + "cmp-nvim-ultisnips"
  dependencies = {
    { 'nvim-mini/mini.icons', version = false },
  },

  version = "1.*",

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    -- See :h blink-cmp-config-keymap
    keymap = {
      preset = "default",

      ["<Tab>"] = { "accept" },
      ["<C-u>"] = { "scroll_documentation_up", "scroll_signature_up" },
      ["<C-d>"] = { "scroll_documentation_down", "scroll_signature_down" },
    },

    appearance = {
      -- "mono" (default) for "Nerd Font Mono" or "normal" for "Nerd Font"
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant  =    "mono"
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = { auto_show = true },

      ghost_text = { enabled = true },

      menu = {
        draw = {
          -- columns = {
          --   { "kind_icon", "kind" } ,
          --   { "label", "label_description", gap = 1 },
          -- },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Experimental signature help support
    signature = { enabled = true },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },

    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
      keymap = {
        preset = "inherit",   -- Inherit the main keymap from above ^
      },
    },
  },

  opts_extend = { "sources.default" }
}
