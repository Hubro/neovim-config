return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "fhill2/telescope-ultisnips.nvim",
  },
  init = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    -- I use these constantly:
    vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>")
    vim.keymap.set("n", "<Bar>f", ":Telescope find_files<CR>")
    vim.keymap.set("n", "<Bar>gr", ":Telescope live_grep_args<CR>") -- 3rd party plugin
    vim.keymap.set("n", "<Bar><Bar>", ":Telescope resume<CR>")

    -- Nice-to-haves if I ever remember to use them:
    vim.keymap.set("i", "<C-s>", "<Space><BS><Esc>:Telescope ultisnips theme=ultisnips<CR>")
    vim.keymap.set("n", "<Bar>b", ":Telescope buffers theme=ivy previewer=false<CR>")
    vim.keymap.set("n", "<Bar>gs", ":Telescope git_status<CR>")
    vim.keymap.set("n", "<Bar>H", ":Telescope oldfiles<CR>")
    vim.keymap.set("n", "<Bar>h", ":Telescope oldfiles only_cwd=true<CR>")
    vim.keymap.set("n", "<Bar>la", ":Telescope lsp_code_actions theme=get_dropdown<CR>")
    vim.keymap.set("n", "<Bar>lr", ":Telescope lsp_references<CR>")
    vim.keymap.set("n", "<Bar>o", ":Telescope lsp_document_symbols theme=outline<CR>")
    vim.keymap.set("n", "<M-p>", ":Telescope git_files<CR>") -- Files tracked by git

    --
    -- My own extensions:
    --

    vim.keymap.set("n", "<Bar>p", ":Telescope nvim-projects<CR>")
    vim.keymap.set("n", "<Bar>s", function() require("hubro.session").session_picker() end)

    -- Find files in the dir of the current buffer
    vim.keymap.set("n", "<Bar>F", function()
      local dir = require("hubro.lib").buf_dir()

      builtin.find_files({
        prompt_title = "Find Files in '" .. dir .. "'",
        search_dirs = { dir },
      })
    end)

    -- Live grep in the dir of the current buffer
    vim.keymap.set("n", "<Bar>GR", function()
      local dir = require("hubro.lib").buf_dir()

      -- Ref: https://github.com/nvim-telescope/telescope-live-grep-args.nvim/blob/master/lua/telescope/_extensions/live_grep_args.lua
      telescope.extensions.live_grep_args.live_grep_args({
        prompt_title = "Live Grep (Args) in '" .. dir .. "'",
        search_dirs = { dir },
      })
    end)
  end,
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")
    local layout_actions = require("telescope.actions.layout")
    local themes = require("telescope.themes")

    -- If there's a .ripgreprc file in the current directory, always use it
    vim.env.RIPGREP_CONFIG_PATH = ".ripgreprc"

    -- My custom actions
    local custom_actions = {
      open_trouble_quickfix = function(_)
        vim.cmd([[Trouble quickfix]])
      end,
      open_dir_in_oil = function(prompt_bufnr)
        local picker = actions_state.get_current_picker(prompt_bufnr)
        local entry = actions_state.get_selected_entry()
        local path = entry[1]
        local stat = vim.loop.fs_stat(path)

        if stat == nil then
          return
        end

        -- Switch focus back to the original window
        -- From: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/actions/set.lua#L127
        vim.api.nvim_set_current_win(picker.original_win_id)

        if stat and stat.type == "directory" then
          vim.cmd.e(path)
        else
          vim.cmd.e(vim.fn.fnamemodify(path, ":h"))
        end
      end,
    }
    custom_actions = require("telescope.actions.mt").transform_mod(custom_actions)

    -- Live grep with arguments
    telescope.load_extension("live_grep_args")

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
        ["<C-->"] = custom_actions.open_dir_in_oil,
      },
      n = {
        ["<C-q>"] = actions.smart_send_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<C-a>"] = actions.smart_add_to_qflist
            + custom_actions.open_trouble_quickfix,
        ["<A-p>"] = layout_actions.toggle_preview,
        ["<C-->"] = custom_actions.open_dir_in_oil,
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
