local success, telescope = pcall(require, "telescope")

-- Don't bother crashing loudly if telescope isn't installed
if success then
  local actions = require("telescope.actions")
  local themes = require("telescope.themes")

  -- Ultisnips extension
  telescope.load_extension("ultisnips")

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

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
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
