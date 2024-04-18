return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "fhill2/telescope-ultisnips.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    local themes = require("telescope.themes")

    -- If there's a .ripgreprc file in the current directory, always use it
    vim.env.RIPGREP_CONFIG_PATH = ".ripgreprc"

    -- My custom actions
    local custom_actions = {
      open_trouble_quickfix = function(_)
        vim.cmd([[Trouble quickfix]])
      end,
    }
    custom_actions = require("telescope.actions.mt").transform_mod(custom_actions)

    -- Ultisnips extension
    telescope.load_extension("ultisnips")

    -- My custom projects extension
    telescope.load_extension("nvim-projects")

    themes.outline = function()
      return themes.get_dropdown({
        previewer = false,
        prompt_title = "Outline",
        initial_mode = "normal",
        layout_config = {
          width = 90,
          height = 30,
        },
        symbols = {
          "File",
          "Module",
          "Namespace",
          "Package",
          "Class",
          "Method",
          "Property",
          "Field",
          "Constructor",
          "Enum",
          "Interface",
          "Function",
          -- "Variable",
          "Constant",
          "String",
          "Number",
          "Boolean",
          "Array",
          "Object",
          "Key",
          "Null",
          "EnumMember",
          "Struct",
          "Event",
          "Operator",
          "TypeParameter",
        },
      })
    end

    themes.ultisnips = function()
      return themes.get_dropdown({
        preview_title = "Ultisnips",
        prompt_title = false,
        results_title = false,
        layout_config = {
          width = 90,
          height = 30,
        },
      })
    end

    local mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<C-a>"] = actions.smart_add_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<A-p>"] = layout_actions.toggle_preview,
      },
      n = {
        ["<C-q>"] = actions.smart_send_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<C-a>"] = actions.smart_add_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<A-p>"] = layout_actions.toggle_preview,
      },
    }

    telescope.setup({
      defaults = {
        mappings = mappings,
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer
            }
          }
        },
        lsp_document_symbols = {
          sorting_strategy = "ascending",
        },
      },
    })
  end,
}
