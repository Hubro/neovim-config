local success, telescope = pcall(require, "telescope")

-- Don't bother crashing loudly if telescope isn't installed
if success then
  local actions = require("telescope.actions")
  local layout_actions = require("telescope.actions.layout")
  local themes = require("telescope.themes")

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

  -- local trouble_installed, trouble = pcall(require, "trouble.providers.telescope")

  -- if trouble_installed then
  --   mappings["i"]["<C-q>"] = trouble.smart_open_with_trouble
  --   mappings["n"]["<C-q>"] = trouble.smart_open_with_trouble
  -- end

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
      lsp_document_symbols = {
        sorting_strategy = "ascending",
      },
    },
  })
end
